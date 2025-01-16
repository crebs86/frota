<?php

namespace App\Frota\Requests;

use App\Traits\ACL;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class FuelRequest extends FormRequest
{
    use ACL;
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return $this->can('Combustivel Ver', 'Combustivel Criar', 'Combustivel Editar', 'Combustivel Apagar');
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, mixed>
     */
    public function rules()
    {
        $this->merge(['car' => (int) getKeyValue($this->car['token'], 'car_token')]);
        $req = $this;
        return [
            'car' => 'exists:cars,id',
            'km' => 'integer|required',
            'quantidade' => 'required|max:255',
            'valor' => 'nullable|max:255',
            'local' => 'nullable|max:255',
            'hora' => ['nullable', 'date_format:H:i', 'required_with:data'],
            'data' => ['nullable', 'date_format:Y-m-d', 'required_with:hora']
        ];
    }
}
