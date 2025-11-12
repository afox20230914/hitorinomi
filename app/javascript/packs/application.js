// application.js

// Turbolinks / Turbo / DOM 全対応
const readyEvents = ["turbolinks:load", "turbo:load", "DOMContentLoaded"];

readyEvents.forEach(evt => {
  document.addEventListener(evt, () => {
    try {
      setupImageModal();
      setupHoursModal();
      setupSelectionUI();
      setupOwnerUI();
      setupDescriptionCounter();
    } catch (e) {
      console.error("[init error]", e);
    }
  });
});

// ========== 画像モーダル ==========
function setupImageModal() {
  const modal   = document.getElementById("image-modal");
  const openBtn = document.getElementById("open-image-modal");
  const closeBtn= document.getElementById("close-image-modal");
  const inputs  = document.querySelectorAll(".image-input");
  const badge   = document.getElementById("image-count-badge");

  if (!modal || !openBtn || !closeBtn) return;

  openBtn.onclick  = () => modal.style.display = "flex";
  closeBtn.onclick = () => modal.style.display = "none";
  modal.addEventListener("click", e => { if (e.target === modal) modal.style.display = "none"; });

  const stored = {}; // { field: File[] }

  inputs.forEach(input => {
    const field = input.dataset.previewTarget;
    if (!field) return;
    if (!stored[field]) stored[field] = [];

    input.addEventListener("change", e => {
      const preview = document.getElementById(`preview-${field}`);
      const newFiles = Array.from(e.target.files || []);
      stored[field] = stored[field].concat(newFiles);

      const total = Object.values(stored).flat().length;
      if (total > 10) {
        alert("アップロードできる画像は合計10枚までです。");
        // 直近追加分を捨てる
        stored[field] = stored[field].slice(0, Math.max(0, stored[field].length - newFiles.length));
        input.value = "";
        return;
      }

      renderPreviews(preview, stored[field], field, stored, badge);
      updateBadge(badge, stored);
      input.value = ""; // 同じファイル再選択対応
    });
  });
}

function renderPreviews(previewTarget, files, field, stored, badge) {
  if (!previewTarget) return;
  previewTarget.innerHTML = "";

  files.forEach((file, idx) => {
    const reader = new FileReader();
    reader.onload = ev => {
      const wrap = document.createElement("div");
      wrap.style.position = "relative";
      wrap.style.display  = "inline-block";

      const img = document.createElement("img");
      img.src = ev.target.result;
      img.style.width  = "100px";
      img.style.height = "100px";
      img.style.objectFit = "cover";
      img.style.borderRadius = "8px";
      img.style.border = "1px solid #ccc";
      img.style.margin = "4px";

      const rm = document.createElement("button");
      rm.textContent = "×";
      rm.style.position = "absolute";
      rm.style.top  = "0";
      rm.style.right= "0";
      rm.style.background = "rgba(0,0,0,0.6)";
      rm.style.color = "#fff";
      rm.style.border = "none";
      rm.style.borderRadius = "0 8px 0 8px";
      rm.style.cursor = "pointer";
      rm.style.width = "24px";
      rm.style.height= "24px";
      rm.style.fontWeight = "bold";

      rm.addEventListener("click", () => {
        stored[field].splice(idx, 1);
        renderPreviews(previewTarget, stored[field], field, stored, badge);
        updateBadge(badge, stored);
      });

      wrap.appendChild(img);
      wrap.appendChild(rm);
      previewTarget.appendChild(wrap);
    };
    reader.readAsDataURL(file);
  });
}

function updateBadge(badge, stored) {
  if (!badge) return;
  const total = Object.values(stored).flat().length;
  if (total > 0) {
    badge.style.display = "flex";
    badge.textContent = total;
  } else {
    badge.style.display = "none";
  }
}

// ========= 営業時間（開閉・定休日制御・行コピー） =========
document.addEventListener("DOMContentLoaded", () => {
  // フォーム開閉（ボタン #open-hours-toggle / 本体 #hours-form）
  const toggleBtn = document.getElementById("open-hours-toggle");
  const hoursForm = document.getElementById("hours-form");
  if (toggleBtn && hoursForm) {
    toggleBtn.addEventListener("click", () => {
      hoursForm.style.display =
        hoursForm.style.display === "none" || hoursForm.style.display === ""
          ? "block"
          : "none";
    });
  }

  const table = document.querySelector("#hours-form table");
  if (!table) return;

// 定休日チェック → 入力無効＆クリア
table.addEventListener("change", (e) => {
  if (!e.target.classList.contains("holiday-checkbox")) return;
  const row = e.target.closest("tr");
  const dis = e.target.checked;
  row.querySelectorAll("input[type='text']").forEach((i) => {
    if (dis) i.value = "";
    i.disabled = dis;
    // ★ここを変更
    i.style.background = dis ? "#ccc" : "#fff";  // ← より濃いグレーに
  });
});


  // 他の曜日へコピー（委譲）
  table.addEventListener("click", (e) => {
    if (!e.target.classList.contains("copy-button")) return;
    e.preventDefault();

    const src = e.target.closest("tr");
    const v = {
      open1:  src.querySelector(".open1")?.value || "",
      open2:  src.querySelector(".open2")?.value || "",
      close1: src.querySelector(".close1")?.value || "",
      close2: src.querySelector(".close2")?.value || "",
    };
    if (!v.open1 && !v.open2 && !v.close1 && !v.close2) return;

    document.querySelectorAll("#hours-form tr[data-day]").forEach((row) => {
      if (row === src) return; // 自分は除外
      if (row.querySelector(".holiday-checkbox")?.checked) return; // 定休日は除外
      row.querySelector(".open1").value  = v.open1;
      row.querySelector(".open2").value  = v.open2;
      row.querySelector(".close1").value = v.close1;
      row.querySelector(".close2").value = v.close2;
    });
  });
});



// ========== カテゴリ/予算/喫煙（画像ボタンの選択制御） ==========
function setupSelectionUI() {
  const groups = [
    { selector: ".category-radio", btn: ".category-btn" },
    { selector: ".budget-radio",   btn: ".budget-btn"   },
    { selector: ".smoking-radio",  btn: ".smoking-btn"  }
  ];

  groups.forEach(group => {
    const radios = document.querySelectorAll(group.selector);
    if (radios.length === 0) return;

    // 初期描画
    radios.forEach(radio => {
      const wrapper = radio.closest(group.btn);
      if (!wrapper) return;
      const overlay = wrapper.querySelector(".overlay");
      const check   = wrapper.querySelector(".checkmark");
      if (radio.checked) {
        overlay.style.display = "none";
        check.style.display   = "block";
      } else {
        overlay.style.display = "block";
        check.style.display   = "none";
      }
    });

    // 切替
    radios.forEach(radio => {
      radio.addEventListener("change", () => {
        radios.forEach(r => {
          const w = r.closest(group.btn);
          if (!w) return;
          w.querySelector(".overlay").style.display   = "block";
          w.querySelector(".checkmark").style.display = "none";
        });
        const w = radio.closest(group.btn);
        w.querySelector(".overlay").style.display   = "none";
        w.querySelector(".checkmark").style.display = "block";
      });
    });
  });
}

// ========== 店舗関係者UI ==========
function setupOwnerUI() {
  const ownerRadios = document.querySelectorAll(".owner-radio");
  const contactField  = document.getElementById("contact-field");
  const contactInput  = document.getElementById("contact_info");
  const requiredLabel = document.getElementById("contact-required");
  if (!ownerRadios.length || !contactField || !contactInput || !requiredLabel) return;

  const showContact = () => {
    contactField.style.display = "block";
    requiredLabel.style.display = "inline";
    contactInput.setAttribute("required", "required");
  };
  const hideContact = () => {
    contactField.style.display = "none";
    requiredLabel.style.display = "none";
    contactInput.removeAttribute("required");
    contactInput.value = "";
  };

  ownerRadios.forEach(radio => {
    const wrapper = radio.closest(".owner-btn");
    const overlay = wrapper.querySelector(".overlay");
    const check   = wrapper.querySelector(".checkmark");

    // 初期表示
    if (radio.checked) {
      overlay.style.display = "none";
      check.style.display   = "block";
      (radio.value === "そうです") ? showContact() : hideContact();
    } else {
      overlay.style.display = "block";
      check.style.display   = "none";
    }

    // 切替
    radio.addEventListener("change", () => {
      ownerRadios.forEach(r => {
        const w = r.closest(".owner-btn");
        w.querySelector(".overlay").style.display   = "block";
        w.querySelector(".checkmark").style.display = "none";
      });
      overlay.style.display = "none";
      check.style.display   = "block";
      (radio.value === "そうです") ? showContact() : hideContact();
    });
  });
}

// ========== 店舗概要 文字数カウンタ ==========
function setupDescriptionCounter() {
  const textarea = document.querySelector("textarea[name='post[description]']");
  const counter  = document.getElementById("char-count");
  if (!textarea || !counter) return;

  const update = () => {
    const len = textarea.value.length;
    counter.textContent = `${len} / 300`;
    counter.style.color = len > 300 ? "#b50000" : "#666";
  };
  textarea.removeEventListener("input", update); // 念のため重複排除
  textarea.addEventListener("input", update);
  update();
}

// ===== カード型ラジオの見た目切替 =====
document.addEventListener("DOMContentLoaded", () => {
  const groups = [
    { inputClass: ".category-radio" },
    { inputClass: ".budget-radio"   },
    { inputClass: ".smoking-radio"  },
    { inputClass: ".owner-radio"    },
  ];

  function refreshByName(name) {
    document.querySelectorAll(`input[type="radio"][name="${name}"]`).forEach(r => {
      const card = r.closest("label");
      if (!card) return;
      const overlay = card.querySelector(".overlay");
      const check   = card.querySelector(".checkmark");
      if (overlay) overlay.style.opacity = r.checked ? "0" : "0.5";
      if (check)   check.style.display  = r.checked ? "block" : "none";
      // ついでに枠の強調（任意）
      card.style.outline = r.checked ? "3px solid #b50000" : "none";
      card.style.borderRadius = "14px";
    });
  }

  groups.forEach(({ inputClass }) => {
    document.querySelectorAll(inputClass).forEach(radio => {
      // 初期表示を実際の選択状態に合わせる
      refreshByName(radio.name);
      // クリック/変更で見た目更新
      radio.addEventListener("change", () => refreshByName(radio.name));
      // ラベルクリック後にも確実に反映
      const card = radio.closest("label");
      if (card) card.addEventListener("click", () =>
        setTimeout(() => refreshByName(radio.name), 0)
      );
    });
  });
});


//= require image_preview
