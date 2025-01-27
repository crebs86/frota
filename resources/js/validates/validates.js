import moment from "moment";

function validateDate(date) {
    return date ? moment(date).isSame(moment(), 'day') || moment(date).isAfter(moment(), 'day') : false
}

export {validateDate}
