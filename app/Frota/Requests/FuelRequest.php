<?php

namespace App\Frota\Requests;

use App\Traits\ACL;
use Illuminate\Foundation\Http\FormRequest;

class FuelRequest extends FormRequest
{
    use ACL;

    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize(): bool
    {
        return $this->can('Combustivel Criar', 'Combustivel Editar') || $this->hasRole('Motorista');
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        $this->merge(['car' => (int)getKeyValue($this->car['token'], 'car_token')]);
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
