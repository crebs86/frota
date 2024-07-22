<?php

namespace App\Http\Requests\Admin;

use App\Models\Setting;
use Illuminate\Validation\Rule;
use Illuminate\Foundation\Http\FormRequest;

class UserRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return auth()->check();
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, mixed>
     */
    public function rules()
    {
        return [
            'name' => 'required|min:3|max:255|string',
            'email' => 'email|required|max:255|unique:users,email,' . $this->user,
            'cpf' => [
                $this->cpfNull(),
                Rule::unique('users')->ignore($this->user),
                Rule::requiredIf(fn () => json_decode(cache()->remember('settings', 60 * 60 * 2, function () {
                    return Setting::where('name', 'general')->first();
                })->settings)->requireCpf[1])
            ],
            'branch_id' => 'int|nullable|exists:branches,id',
            'notes' => 'nullable|min:3|max:510',
            'password' => 'nullable|min:8|confirmed'
        ];
    }

    public function messages()
    {
        return [
            'cpf.unique' => 'Este CPF já se encontra em uso',
            'cpf.required' => 'Informe seu CPF',
            'branch_id.exists' => 'Uma ou mais unidades informadas não existem. Favor selecionar um item da lista.'
        ];
    }

    private function cpfNull(): string
    {
        if (
            json_decode(cache()->remember('settings', 60 * 60 * 2, function () {
                return Setting::where('name', 'general')->first();
            })->settings)->requireCpf[1]
            ||
            (!json_decode(cache()->remember('settings', 60 * 60 * 2, function () {
                return Setting::where('name', 'general')->first();
            })->settings)->requireCpf[1] && $this->cpf)
        ) {
            return 'cpf';
        } else {
            return 'nullable';
        }
    }
}
