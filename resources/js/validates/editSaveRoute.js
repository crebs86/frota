export default function validateESR(value) {
  let errors = '{"errors":{';
  let partial = "";

  if (!value.time) {
    partial += '"time": ["Informe um horário."],';
  }

  if (!value.branch?.id) {
    partial += '"branch": ["Informe uma unidade destino."],';
  }

  if (value.branch?.id === 1) {
    if (!value.local) {
      partial += '"local": ["Informe um local destino avulso."],';
    }
  }

  if (!value._checker) {
    partial += '"_checker": ["Erro ao carregar dados essenciais."],';
  }

  if (partial.length === 0) {
    errors += '"_run":true}}';
  } else {
    errors += "" + partial + ' "_run":false}}';
  }

  return JSON.parse(errors).errors;
}
