<?php

namespace App\Frota\Requests;

use Illuminate\Validation\Rule;
use Illuminate\Foundation\Http\FormRequest;

class DriverRequest extends FormRequest
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
            'id' => ['int', 'requiredOnCreate', Rule::unique('drivers')->ignore($this->driver)],
            'garagem_id' => ['int', 'nullable', Rule::exists('garages', 'id')],
            'carro_favorito' => ['int', 'nullable', Rule::exists('cars', 'id')],
            'proprio' => 'boolean',
            'cnh' => 'boolean|nullable',
            'matricula' => 'max:25|string|required|regex:/^[0-9]+$/',

        ];
    }

    public function messages()
    {
        return [
            'id.unique' => 'Motorista já cadastrado.',
            'matricula.string' => 'Informe uma matrícula válida'
        ];
    }
}
