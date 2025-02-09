window.addEventListener("message", function(event) {
    if (event.data.action === "show") {
        document.getElementById("roupas-list").innerHTML = "";
        document.getElementById("props-list").innerHTML = ""; // Limpa a lista de props

        // Exibe as roupas
        event.data.roupas.forEach(roupa => {
            let li = document.createElement("li");
            li.textContent = `${roupa.nome}: ${roupa.id}`;
            document.getElementById("roupas-list").appendChild(li);
        });

        // Exibe os props
        event.data.props.forEach(prop => {
            let li = document.createElement("li");
            li.textContent = `${prop.nome}: ${prop.id}`;
            document.getElementById("props-list").appendChild(li);
        });

        document.body.style.display = "flex"; // Agora a UI só aparece ao usar o comando
    } else if (event.data.action === "hide") {
        document.body.style.display = "none"; // Esconde ao fechar
    }
});

function fecharUI() {
    document.body.style.display = "none"; // Esconde a UI
    fetch(`https://${GetParentResourceName()}/fechar`, { method: "POST" });
}
