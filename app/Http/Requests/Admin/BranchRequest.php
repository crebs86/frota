<?php

namespace App\Http\Requests\Admin;

use Illuminate\Validation\Rule;
use Illuminate\Foundation\Http\FormRequest;

class BranchRequest extends FormRequest
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
            'name' => 'string|min:3|max:255',
            'cnpj' => ['string', 'cnpj', Rule::unique('branches')->ignore($this->id), 'nullable'],
            'email' => 'string|email|max:155|nullable',
            'cep' => 'string|size:8|nullable',
            'address' => 'string|max:510',
            'phones' => 'string|max:255|nullable',
            'notes' => 'string|max:255|nullable'
        ];
    }

    public function messages()
    {
        return [
            'cnpj.unique' => 'CNPJ já está em uso'
        ];
    }
}
