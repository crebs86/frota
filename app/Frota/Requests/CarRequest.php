<?php

namespace App\Frota\Requests;

use App\Traits\ACL;
use Illuminate\Validation\Rule;
use Illuminate\Foundation\Http\FormRequest;

class CarRequest extends FormRequest
{
    use ACL;
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize(): bool
    {
        return $this->can('Carro Criar', 'Carro Editar');
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
            'garagem_id' => ['int', 'nullable', Rule::exists('garages', 'id')],
            'marca' => 'max:25',
            'modelo' => 'max:55',
            'placa' => 'max:7|unique:cars,placa,' . $req->car?->id,
            'patrimonio' => 'boolean|nullable',
            'tombo' => ['max:55', 'nullable', Rule::requiredIf(function () use ($req) {
                return $req->patrimonio === true;
            })]
        ];
    }

    public function messages(): array
    {
        return [
            'garagem_id.exists' => 'Garagem não existe.',
            'tombo.max' => 'Número de patrimônio muito grande.',
            'tombo.required' => 'Informe o número de patrimônio.',
            'placa.unique' => 'Já existe um veículo cadastrado com a placa informada.'
        ];
    }
}
