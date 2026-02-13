//AJAX EXMAPLE(Short polling) :- client requests data asynchronously -> server responds 
// -> UI updates without refresh

function loadData(){

    var request = new XMLHttpRequest()

    request.onreadystatechange = function () {
        if(request.readyState === 4 && request.status === 200){
            document.getElementById("demo").innerHTML = request.responseText
        }
    }

    request.open("GET", "data.txt", true)
    request.send()
}

setInterval(loadData, 5000);  //calls loaddata on every 5 seconds