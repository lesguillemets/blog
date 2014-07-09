window.onload = show;

function show(){
  var loc = window.location.href;
  if (/.*categories.html#.*$/.test(loc)){
    var cat = loc.split("#")[1];
    document.getElementById("heading").innerHTML = "Category: " + cat;
    document.getElementById(cat).style.display = "initial";
  }
  else {
    if(document.getElementsByClassName){
      var cats = document.getElementsByClassName("category");
      for (var i=0; i<cats.length; i++){
        cats[i].style.display = "initial";
      }
    }
    else {
      var allElements = document.getElementsByTagName('*');
      for (var i=0; i<allElements.length; i++){
        if (allElements[i].className === "category"){
          allElements[i].style.display = "initial";
        }
      }
    }
  }
}
