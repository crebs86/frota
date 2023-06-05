<?php

namespace App\Frota\Requests;

use Illuminate\Validation\Rule;
use Illuminate\Foundation\Http\FormRequest;

class GarageRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, mixed>
     */
    public function rules()
    {
        return [
            'id' => ['int', 'required', Rule::exists('branches', 'id'), Rule::unique('garages')],
        ];
    }

    public function messages()
    {
        return [
            'id.unique'=> 'Garagem já está cadastrada',
            'id.exists'=> 'Não foi encontrada unidade na base de dados.'
        ];
    }
}
