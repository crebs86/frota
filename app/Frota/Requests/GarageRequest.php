<?php

namespace App\Frota\Requests;

use App\Traits\ACL;
use Illuminate\Validation\Rule;
use Illuminate\Foundation\Http\FormRequest;

class GarageRequest extends FormRequest
{
    use ACL;
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return $this->can('Garagem Ver', 'Garagem Criar', 'Garagem Editar' ,'Garagem Apagar');
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, mixed>
     */
    public function rules()
    {
        return [
            'id' => ['int', Rule::exists('branches', 'id'), Rule::unique('garages')],
        ];
    }

    public function messages()
    {
        return [
            'id.unique' => 'Garagem já está cadastrada',
            'id.exists' => 'Não foi encontrada a unidade referência na base de dados.'
        ];
    }
}
