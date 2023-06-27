<?php

namespace App\Frota\Requests;

use App\Traits\ACL;
use Illuminate\Validation\Rule;
use Illuminate\Foundation\Http\FormRequest;

class ScheduleTemplateRequest extends FormRequest
{
    use ACL;
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return $this->can('Modelo Agenda Criar', 'Modelo Agenda Editar');
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, mixed>
     */
    public function rules()
    {

        return [
            'driver' => ['int', 'required', Rule::unique('schedule_templates', 'driver')->ignore($this->driver, 'driver'), Rule::exists('drivers', 'id')],
            'timesMorningStart' => [Rule::requiredIf($this->timesMorningEnd), 'lt:' . $this->timesMorningEnd, 'nullable'],
            'timesMorningEnd' => [Rule::requiredIf($this->timesMorningStart), 'gt:' . $this->timesMorningStart, 'nullable'],
            'timesAfternoonStart' => [Rule::requiredIf($this->timesAfternoonEnd), 'lt:' . $this->timesAfternoonEnd, 'nullable'],
            'timesAfternoonEnd' => [Rule::requiredIf($this->timesAfternoonStart), 'gt:' . $this->timesAfternoonStart, 'nullable'],
            'timesNightStart' => [Rule::requiredIf($this->timesNightEnd), 'lt:' . $this->timesNightEnd, 'nullable'],
            'timesNightEnd' => [Rule::requiredIf($this->timesNightStart), 'gt:' . $this->timesNightStart, 'nullable'],
            'timesSpecialStart' => [Rule::requiredIf($this->timesSpecialEnd), 'lt:' . $this->timesSpecialEnd, 'nullable'],
            'timesSpecialEnd' => [Rule::requiredIf($this->timesSpecialStart), 'gt:' . $this->timesSpecialStart, 'nullable']
        ];
    }

    public function messages()
    {
        return [
            'lt' => 'A hora de início deve ser menor do que a hora de término.',
            'gt' => 'A hora de término deve ser maior do que a hora de início.',
        ];
    }
}
