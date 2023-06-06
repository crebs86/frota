<?php

namespace App\Frota\Requests;

use Illuminate\Validation\Rule;
use Illuminate\Foundation\Http\FormRequest;

class CarRequest extends FormRequest
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
            'garagem_id' => ['int', 'nullable', Rule::exists('garages', 'id')],
            'marca' => 'max:25',
            'modelo' => 'max:55',
            'placa' => 'max:7',
            'patrimonio' => 'boolean|nullable',
            'tombo' => 'max:55|nullable'
        ];
    }

    public function messages()
    {
        return [
            'garagem_id.exists' => 'Garagem não existe.',
            'tombo.max' => 'Número de patrimônio muito grande.',
        ];
    }
}
