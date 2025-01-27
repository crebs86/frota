function driverName({id, user}) {
    return `${id ? id : ''} - ${user?.name ? user.name : ''}`
}

function branchName({id, name}) {
    if (id === 1) {
        return `${id ? id : ''} - Não Cadastrado`
    } else {
        return `${id ? id : ''} - ${name ? name : ''}`
    }
}

export {driverName, branchName}
