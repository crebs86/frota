<?php

namespace App\Regulacao\Requests;

use App\Traits\ACL;
use Illuminate\Validation\Rule;
use Illuminate\Foundation\Http\FormRequest;

class PostoColetaRequest extends FormRequest
{
    use ACL;

    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize(): bool
    {
        return $this->can('Regulacao Criar', 'Regulacao Editar');
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        $this->id = cripto($this->hash, 'branche', 2);
        return [
            'id' => ['int', Rule::exists('branches', 'id'), Rule::unique('postos_coleta')],
        ];
    }

    public function messages(): array
    {
        return [
            'id.unique' => 'Posto de Coleta já está cadastrada',
            'id.exists' => 'Não foi encontrada a unidade referência na base de dados.'
        ];
    }
}
