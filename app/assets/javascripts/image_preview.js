document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('.image-input').forEach(function(input) {
    input.addEventListener('change', function() {
      const target = input.dataset.previewTarget;
      const previewArea = document.getElementById('preview-' + target);
      if (!previewArea) return;

      previewArea.innerHTML = '';
      Array.from(input.files).forEach(function(file) {
        if (!file.type.match('image.*')) return;

        const reader = new FileReader();
        reader.onload = function(evt) {
          const wrapper = document.createElement('div');
          wrapper.style.display = 'inline-block';
          wrapper.style.textAlign = 'center';
          wrapper.style.margin = '5px';

          const img = document.createElement('img');
          img.src = evt.target.result;
          img.style.maxWidth = '160px';
          img.style.borderRadius = '10px';
          img.style.boxShadow = '0 2px 4px #ccc';
          wrapper.appendChild(img);

          if (target === 'sub_images') {
            const select = document.createElement('select');
            select.name = 'post[sub_images_category][]';
            select.required = true;
            select.style.display = 'block';
            select.style.width = '160px';
            select.style.margin = '8px auto 0 auto';
            select.style.padding = '4px';

            const options = [
              { text: '選択してください', value: '' },
              { text: '店舗外観', value: 'exterior_images' },
              { text: '店舗内館', value: 'interior_images' },
              { text: '料理', value: 'food_images' },
              { text: 'メニュー', value: 'menu_images' }
            ];
            options.forEach(opt => {
              const o = document.createElement('option');
              o.textContent = opt.text;
              o.value = opt.value;
              select.appendChild(o);
            });
            wrapper.appendChild(select);
          }

          previewArea.appendChild(wrapper);
        };
        reader.readAsDataURL(file);
      });
    });
  });
});
