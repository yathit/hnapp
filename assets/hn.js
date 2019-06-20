['TD.title { font-size: 14pt }',
  'DIV.comment {font-size: 12pt;}',
  'A.togg { padding: 8px; background-color: rgb(255, 102, 0);}'].forEach(function (css) {
  document.styleSheets[0].insertRule(css, 0);
});


document.querySelector('table.itemlist').addEventListener('click', function (ev) {
  if (ev.target && ev.target.id &&  ev.target.tagName == 'TR' ) {
    document.location.href = 'item?id=' + ev.target.id;
  }
}, false);