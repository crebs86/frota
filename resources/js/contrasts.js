import has from "./arrayHelpers";

function styles(style) {
    let l = style.split(" ");
    let styles = "";
    l.map((item) => {
        let i = item.split("-");
        if (has([i[2]], ["100", "200", "300", "400", "500"])) {
            styles += i[0] + "-" + i[1] + "-" + (parseInt(i[2]) + 300) + " ";
        } else if (i[2] == 50) {
            styles += i[0] + "-" + i[1] + "-300 ";
        } else {
            styles += i[0] + "-" + i[1] + "-" + (parseInt(i[2]) - 300) + " ";
        }
    });
    return styles;
}

/**
 *
 * @param {int} task
 * @param {string} status
 * @returns
 */
function getStyles(task, status) {
    if (task) {
        return "bg-green-500 border-green-800 text-green-800";
    }
    switch (status) {
        case 0:
            return "bg-yellow-500 border-yellow-800 text-yellow-800";
        case 1:
            return "bg-teal-500 border-teal-800 text-teal-800";
        case 2:
            return "bg-red-500 border-red-800 text-red-800";
        case 3:
            return "bg-blue-300 border-blue-800 text-blue-800";
        case 4:
            return "bg-fuchsia-500 border-fuchsia-800 text-fuchsia-800";
        default:
            return "";
    }
}

export { styles, getStyles };
