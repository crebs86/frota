import has from "@/arrayHelpers";

export default function validate(value, ignore = []) {
  let errors = '{"errors":{';
  let partial = "";

  if (!value.driver?.id && !has(ignore, ['driver'])) {
    partial += '"driver": ["Erro ao carregar motorista."],';
  }

  if (!value.date && !has(ignore, ['date'])) {
    partial += '"date": ["Informa uma data."],';
  }

  if (!value.time && !has(ignore, ['time'])) {
    partial += '"time": ["Informe um horário."],';
  }

  if (!value.duration && !has(ignore, ['duration'])) {
    partial += '"duration": ["Informe uma duração."],';
  }

  if (value.passengers.length < 1 && !has(ignore, ['passengers'])) {
    partial += '"passengers": ["Informe ao menos um passageiro."],';
  }

  if (!value.branch?.id && !has(ignore, ['branch'])) {
    partial += '"branch": ["Informe uma unidade destino."],';
  }

  if (value.branch?.id === 1) {
    if (!value.local && !has(ignore, ['local'])) {
      partial += '"local": ["Informe um local destino avulso."],';
    }
  }

  if (partial.length === 0) {
    errors += '"_run":true}}';
  } else {
    errors += "" + partial + ' "_run":false}}';
  }

  return JSON.parse(errors).errors;
}
