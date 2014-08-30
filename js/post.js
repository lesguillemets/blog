(function(){
  window.addEventListener("load", setup);
  function setup(){
    setFootnoteTitles();
  }
  function setFootnoteTitles(){
    footTags = document.getElementsByClassName("footnote");
    for (var i=0; i<footTags.length; i++){
      var footTag = footTags[i];
      var footNote = document.getElementById((footTag.getAttribute("href")).slice(1));
      var text = footNote.getElementsByTagName("p")[0];
      footTag.setAttribute('title',text['textContent']);
    }
  }
})();

