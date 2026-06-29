let datos = [];

// 1. CREATE
function crear() {
    let input = document.getElementById('inputNombre');
    if (input.value !== "") {
        datos.push(input.value);
        input.value = "";
        leer();
    }
}

// 2. READ
function leer() {
    let lista = document.getElementById('lista');
    lista.innerHTML = "";

    for (let i = 0; i < datos.length; i++) {
        lista.innerHTML += `
            <li>
                ${datos[i]} 
                <button onclick="actualizar(${i})">Editar</button>
                <button onclick="eliminar(${i})">Eliminar</button>
            </li>
        `;
    }
}

// 3. UPDATE
function actualizar(indice) {
    let nuevoNombre = prompt("Edita el nombre:", datos[indice]);
    if (nuevoNombre !== null && nuevoNombre !== "") {
        datos[indice] = nuevoNombre;
        leer();
    }
}

// 4. DELETE
function eliminar(indice) {
    datos.splice(indice, 1);
    leer();
}
