// 関数名をloadPreviewに統一
function loadPreview(input) {
  const preview = document.getElementById('icon-preview');
  if (input.files && input.files[0]) {
    const reader = new FileReader();
    reader.onload = function(e) {
      preview.src = e.target.result;
    };
    reader.readAsDataURL(input.files[0]);
  }
}

