Store.create!(
  name: "ひとり居酒屋 炙りや",
  postal_code: "5300001",
  prefecture: "大阪府",
  city: "大阪市北区",
  address_detail: "梅田1-1-1",
  opening_time: "17:00",
  closing_time: "23:00",
  seating_capacity: "20席",
  store_type: "居酒屋",  # ✅ 正しくはコレ
  smoking_allowed: "禁煙",
  holidays: "日曜日",
  budget: 2500,
  Comment.create!(
  user: user,
  store: store,
  body: "最高のお店でした！",
  good_count: 5,
  bad_count: 0
  user_id: User.first.id,
  is_owner: true
)