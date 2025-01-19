<?php

namespace App\Frota\Requests;

use App\Traits\ACL;
use Illuminate\Validation\Rule;
use Illuminate\Foundation\Http\FormRequest;

class DriverRequest extends FormRequest
{
    use ACL;
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize(): bool
    {
        return $this->can('Motorista Criar', 'Motorista Editar');
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        $req = $this;
        return [
            'id' => ['int', Rule::unique('drivers')->ignore($this->driver)],
            'garagem_id' => ['int', 'nullable', Rule::exists('garages', 'id')],
            'carro_favorito' => ['int', 'nullable', Rule::exists('cars', 'id')],
            'proprio' => 'boolean',
            'cnh' => 'boolean|nullable',
            'matricula' => [
                'max:25', 'string', 'regex:/^[0-9]+$/', 'nullable', Rule::requiredIf(function () use ($req) {
                    return $req->proprio === true;
                })
            ],

        ];
    }

    public function messages(): array
    {
        return [
            'id.unique' => 'Motorista já cadastrado.',
            'matricula.string' => 'Informe uma matrícula válida'
        ];
    }
}
