<?php

namespace App\Http\Controllers\Admin;

use App\Traits\ACL;
use App\Models\User;
use Inertia\Inertia;
use Inertia\Response;
use App\Models\Branch;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Spatie\Permission\Models\Role;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;
use Illuminate\Http\RedirectResponse;
use App\Http\Requests\Admin\UserRequest;
use App\Mail\WelcomeUser;
use App\Models\AclUpdate;
use App\Models\UserUpdate;
use App\Traits\Helpers;
use Exception;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\Mail;

class UserController extends Controller
{
    use ACL, Helpers;

    /**
     * Página inicial de controle de acesso de usuários
     *
     * @param Request $request
     *
     * @return Response
     */
    public function index(Request $request): Response
    {
        if ($this->can('ACL Editar', 'ACL Ver', 'ACL Criar', 'ACL Apagar', 'Usuario Editar', 'Usuario Ver', 'Usuario Criar', 'Usuario Apagar')) {
            if (!$request->user) {
                $users = User::orderBy('updated_at', 'desc')->withTrashed()->paginate(10)->through(
                    function ($users) {
                        return $this->setUser($users);
                    }
                );
            } else {
                $users = $this->findUsers($request->user);
            }
            return Inertia::render('Admin/AclUsers', [
                'users' => $users ?? null,
                'keyword' => $request->user ?? ''
            ]);
        }
        return Inertia::render('Admin/403');
    }

    /**
     * Pesquisa por usuários na base de dados;
     * termos aproximados: name e email;
     * termos exatos: id e CPF.
     *
     * @param string $keyword
     *
     * @return LengthAwarePaginator
     */
    private function findUsers(string $keyword): LengthAwarePaginator
    {
        $x = [
            'len' => strlen($keyword),
            'is_num' => is_numeric(str_replace('.', '', str_replace('-', '', $keyword)))
        ];
        if (!($x['is_num']) && $x['len'] < 4) {
            return [];
        }
        return User::select('id', 'name', 'email', 'cpf', 'deleted_at')
            ->where(
                function ($q) use ($keyword, $x) {
                    if ($x['is_num'] && $x['len'] < 11) {
                        return $q->where('id', str_replace('.', '', str_replace('-', '', $keyword)));
                    } elseif ($x['is_num'] && $x['len'] === 11) {
                        return $q->where('cpf', str_replace('.', '', str_replace('-', '', $keyword)));
                    }
                    return $q;
                }
            )
            ->orWhere(
                function ($q) use ($keyword, $x) {
                    if (!($x['is_num']) && $x['len'] >= 4) {
                        return $q->where('name', 'like', '%' . $keyword . '%');
                    }
                    return $q;
                }
            )
            ->orWhere(
                function ($q) use ($keyword, $x) {
                    if (!$x['is_num'] && $x['len'] >= 4) {
                        return $q->where('email', 'like', '%' . $keyword . '%');
                    }
                    return $q;
                }
            )
            ->withTrashed()
            ->paginate(50)->through(
                function ($user) {
                    return $this->setUser($user);
                }
            );
    }

    /**
     * Lança dados da pesquisa do usuário em um array
     *
     * @param User $user
     *
     * @return array
     */
    private function setUser(User $user): array
    {
        return [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'cpf' => $user->cpf,
            'deleted_at' => $user->deleted_at
        ];
    }

    public function listUserAndRoles(Request $request)
    {
        return $this->showUserAndRoles($request);
    }

    /**
     * Página exibe dados básicos do usuário e papéis vinculados a este
     *
     * @param Request $request
     *
     * @return Response
     */
    public function showUserAndRoles(Request $request): Response
    {
        if ($this->can('ACL Ver', 'ACL Editar')) {
            $userRoles = $this->getUserRoles($request->id);
            $allRoles = Role::orderBy('name')
                ->where(function ($q) {
                    if (!$this->hasRole(config('crebs86.admin_roles_edit'))) {
                        $a = [];
                        foreach (config('crebs86.admin_roles') as $v) {
                            $a[] = ['name', '<>', $v];
                        }
                        $q->where($a);
                    } else {
                        $q;
                    }
                })
                ->select(['id', 'name'])
                ->get()->toArray();

            $r = $userRoles->toArray();

            if (isset($r['roles'])) {
                $ur = $this->setCurrentRoles($allRoles, $r);
            }
            $edit = true;
            if ($userRoles->hasRole(config('crebs86.admin_roles'))) {
                $edit = $this->hasRole(config('crebs86.admin_roles_edit'));
            }

            return Inertia::render('Admin/UserRoles', [
                'user' => $userRoles,
                'userRoles' => $ur,
                'edit' => $edit,
                '_checker' => setGetKey($request->id, 'edit_user_role')
            ]);
        }
        return Inertia::render('Admin/403');
    }

    /**
     * Define a situação de cada papél em relaçao ao usuário
     *
     * @param mixed $allRoles
     * @param mixed $r
     *
     * @return array
     */
    private function setCurrentRoles($allRoles, $r): array
    {
        $ur = [];
        foreach ($allRoles as $ar) {
            $ur[] = [
                'id' => $ar['id'],
                'name' => $ar['name'],
                'has' => in_array(
                    $ar['id'],
                    array_column($r['roles'], 'id')
                ) ? true : false
            ];
        }
        return $ur;
    }

    /**
     * Busca papeis de usuários
     *
     * @param mixed $id
     *
     * @return User
     */
    private function getUserRoles($id): User
    {
        return User::select('id', 'name', 'cpf', 'email')->withTrashed()->where('id', $id)
            ->with(
                [
                    'roles' => function ($q) {
                        $q->select('id', 'name')->orderBy('id');
                    }
                ]
            )
            ->first();
    }

    /**
     * Sincroniza papéis dos usuários
     *
     * @param Request $request
     *
     * @return JsonResponse
     */
    public function editUserRole(Request $request): JsonResponse|User
    {
        $r = $request->all();
        $hasNoPrivileges = !$this->hasRole(config('crebs86.admin_roles_edit'));
        if (count(array_intersect($r['roles'], config('crebs86.admin_roles'))) > 0 && $hasNoPrivileges) {
            return response()->json('Papéis de usuário: você não possui permissão para editar papél administrador', 403);
        }
        if ($this->can('ACL Editar')) {
            if (getKeyValue($r['_checker'], 'edit_user_role') === $request->id) {

                $user = User::where('id', $request->id)
                    ->select('id')
                    ->withTrashed()
                    ->with(
                        [
                            'roles' => function ($q) {
                                $q->select('id', 'name', 'updated_at')->orderBy('id');
                            }
                        ]
                    )
                    ->first();
                $before = array_merge(collect($user)->all(), ['roles' => [$user->roles->pluck('id', 'name')->all()]]);

                if ($user->hasRole(config('crebs86.admin_roles')) && $hasNoPrivileges) {
                    return response()->json('Papéis de usuário: você não possui permissão para editar usuário administrador', 403);
                }

                $return = $user->syncRoles($r['roles']);

                $after = array_merge(collect($user)->all(), ['roles' => [$user->roles->pluck('id', 'name')->all()], 'updated_at' => now()]);

                $this->auditable('userRolesPermissions') ? $this->saveUpdates(collect($before)->all(), json_decode(json_encode($after)), AclUpdate::class, ['roles', 'updated_at']) : null;

                return $return;
            }
            return response()->json('Payload: erro ao acessar aplicação', 403);
        }
        return response()->json('Papéis de usuário: você não possui permissão para acessar este recurso', 403);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Inertia\Response
     */
    public function create(): Response
    {
        if ($this->can('Usuario Criar')) {
            return Inertia::render('Admin/UserCreate', [
                'branches' => Branch::orderBy('name')->select(['id', 'name'])->get()
            ]);
        }
        return Inertia::render('Admin/403');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param Request $request
     * @param User $user
     * @return Response|RedirectResponse
     */
    public function store(Request $request, User $user): Response|RedirectResponse
    {
        if ($this->can('Usuario Criar')) {
            $pass = Str::random(8);
            $request->validate([
                'name' => 'required|string|max:255',
                'email' => 'required|string|email|max:255|unique:users',
                'cpf' => 'nullable|cpf|unique:users',
                'branch_id' => 'nullable|exists:branches,id',
                'notes' => 'nullable|min:3|max:510'
            ], [
                'cpf.unique' => 'Este CPF já se encontra em uso'
            ]);

            $user = User::create([
                'name' => $request->name,
                'email' => $request->email,
                'cpf' => preg_replace("/[^0-9]/", "", $request->cpf),
                'branch_id' => $request->branch_id,
                'notes' => $request->notes,
                'password' => Hash::make($pass),
            ]);

            $message = 'Usuário ' . $user->name . ' foi criado com sucesso! Enviado email de boas vindas';
            $type = 'success';

            try {
                throw new Exception('Algo errado');
                if (config('queue.default') === 'redis') {
                    Mail::to($user)->queue(new WelcomeUser($user, $pass));
                } else {
                    Mail::to($user)->send(new WelcomeUser($user, $pass));
                }
            } catch (Exception $e) {
                $message = 'Usuário ' . $user->name . ' foi criado com sucesso! Erro ao enviar email de boas vindas';
                $type = 'warning';
            }


            if ($user) {
                return redirect(route('admin.acl.users.show', $user->id))->with($type, $message);
            }

            return redirect()->back()->with('error', 'Ocorreu um erro ao criar usuário');
        }
        return Inertia::render('Admin/403');
    }

    /**
     * Exibe formulário de edição do usuário selecionado
     */
    public function show(Request $request): Response
    {
        return $this->edit($request);
    }

    /**
     * @param Request $request
     *
     * @return Response
     */
    public function edit(Request $request): Response
    {
        if ($this->can('Usuario Ver', 'Usuario Editar', 'Usuario Apagar')) {
            if ($user = User::select('id', 'name', 'cpf', 'email', 'notes', 'branch_id', 'deleted_at', 'email_verified_at')
                ->with('branch')
                ->withTrashed()->find($request->user) ?? []
            ) {

                $branches = Branch::orderBy('name')->select(['id', 'name'])->get();

                return Inertia::render(
                    'Admin/UserEdit',
                    [
                        'user' => $user,
                        'branches' => $branches,
                        '_checker' => setGetKey($request->user, 'edit_user_account')
                    ]
                );
            }
        }
        return Inertia::render('Admin/403');
    }

    /**
     * Atualiza usuário com dados recebidos do formulário
     *
     * @param UserRequest $request
     *
     * @return Response
     */
    public function update(UserRequest $request): Response|RedirectResponse
    {
        if ($this->can('Usuario Editar', 'Usuario Apagar')) {

            if ((int)getKeyValue($request->_checker, 'edit_user_account') === (int)$request->user) {

                $user = User::withTrashed()
                    ->find($request->user);
                $u = collect($user)->all();

                $updated = $user->update(
                    [
                        'email' => $request->email,
                        'name' => $request->name,
                        'cpf' => $request->cpf ? preg_replace("/[^0-9]/", "", $request->cpf) : null,
                        'deleted_at' => $request->active ? null : now(),
                        'branch_id' => $request->branch_id,
                        'notes' => $request->notes
                    ]
                );

                if ($updated) {
                    if (!$u['deleted_at'] != $request->active) {
                        resetCache('drivers');
                    }
                    //se sucesso na atualização do usuário e pedido de reset de senha.
                    if ($request->password) {
                        $password = $user->forceFill([
                            'password' => Hash::make($request->password)
                        ])->save();
                    }

                    $this->auditable('users') ? $this->saveUpdates($u, $user, UserUpdate::class, ['name', 'email', 'cpf', 'email_verified_at', 'notes', 'deleted_at', 'branch_id', 'updated_at'], ['branch_id']) : null;
                    return redirect()->back()->with('success', 'O usuário foi atualizado');
                } else {
                    return redirect()->back()->with('error', 'Erro ao atualizar conta do usuário');
                }
            } else {
                return redirect()->back()->with('error', 'Payload: erro ao acessar aplicação');
            }
        }
        return Inertia::render(
            'Admin/403',
            [
                'flash.error' => 'Você não possui permissão para usar este recurso'
            ]
        );
    }

    /**
     * marca e-mail como verificado
     *
     * @param Request $request
     *
     * @return Response
     */
    public function userVerifyEmail(Request $request): Response|RedirectResponse
    {
        if ($this->can('Usuario Editar')) {
            if ((int)getKeyValue($request->_checker, 'edit_user_account') === (int)$request->id) {
                $user = User::withTrashed()
                    ->find($request->id);
                $u = collect($user)->all();
                if ($user->update(
                    [
                        'email_verified_at' => now()
                    ]
                )) {
                    $this->auditable('users') ? $this->saveUpdates($u, $user, UserUpdate::class, ['name', 'email', 'cpf', 'email_verified_at', 'notes', 'deleted_at', 'branch_id', 'updated_at']) : null;
                    return redirect()->back()->with('success', 'Email verificardo com sucesso');
                } else {
                    return redirect()->back()->with('error', 'Erro ao solicitar verificação de e-mail');
                }
            } else {
                return redirect()->back()->with('error', 'Payload: erro ao acessar aplicação');
            }
        }
        return Inertia::render('Admin/403')->with('error', 'Você não possui permissão para usar este recurso');
    }

    /**
     * Envia link de verificação de e-mail para o endereço cadastrado
     *
     * @param Request $request
     *
     * @return [type]
     */
    public function requireEmailVerification(Request $request)
    {
        if ($this->can('Usuario Editar')) {
            if ((int)getKeyValue($request->_checker, 'edit_user_account') === (int)$request->id) {
                $user = User::withTrashed()
                    ->find($request->id);
                $u = collect($user)->all();
                if ($user->update(
                    [
                        'email_verified_at' => null
                    ]
                )) {
                    $this->auditable('users') ? $this->saveUpdates($u, $user, UserUpdate::class, ['name', 'email', 'cpf', 'email_verified_at', 'notes', 'deleted_at', 'branch_id', 'updated_at']) : null;
                    return redirect()->back()->with('success', 'Usuário deverá fazer login e solicitar link de verificação de e-mail');
                } else {
                    return redirect()->back()->with('error', 'Erro ao solicitar verificação de e-mail');
                }
            } else {
                return redirect()->back()->with('error', 'Payload: erro ao acessar aplicação');
            }
        }
        return Inertia::render('Admin/403')->with('error', 'Você não possui permissão para usar este recurso');
    }

    /**
     * Página da conta do usuário
     *
     * @return Response
     */
    public function account(): Response
    {
        return Inertia::render('Admin/Account');
    }

    /**
     * Atualiza os dados do usuário
     *
     * @param Request $request
     *
     * @return Response
     */
    public function updateAccount(Request $request): Response
    {
        $request->validate(
            [
                'name' => 'string|required|min:3|max:255',
                'email' => 'email|required|unique:users,id'
            ]
        );

        $account = User::find(auth()->id());
        $request->user()->update([
            'name' => $request->name,
            'email' => $request->email,
            'email_verified_at' => $request->user()->email === $request->email ? $request->user()->email_verified_at : null
        ]);
        $this->auditable('users') ? $this->saveUpdates($account, $request->user(), UserUpdate::class, ['name', 'email', 'cpf', 'email_verified_at', 'notes', 'deleted_at', 'branch_id', 'updated_at']) : null;

        return Inertia::render('Admin/Account', [
            'message' => 'Sua conta foi atualizada!'
        ]);
    }

    /**
     * atualiza senha
     *
     * @param Request $request
     *
     * @return [type]
     */
    public function updatePassword(Request $request)
    {
        $request->validate([
            'current_password' => 'required',
            'password' => 'required|confirmed',
        ]);
        if (Hash::check($request->current_password, auth()->user()->password)) {
            $request->user()->forceFill([
                'password' => Hash::make($request->password),
                'remember_token' => Str::random(60),
            ])->save();

            return redirect()->back()->with([
                'success' => 'Sua senha foi alterada com sucesso!'
            ]);
        } else {
            return redirect()->back()->with([
                'error' => 'Ops! Senha incorreta.'
            ]);
        }
    }
}
