class Item < ApplicationRecord
  belongs_to :category
  belongs_to :user
  belongs_to :status
  belongs_to :size
  has_many :images, dependent: :delete_all
  has_one :order

  enum condition: {
    unused: 1, like_new: 2, invisibly_damaged: 3, slightly_damaged: 4, damaged: 5, bad: 6
  }

  enum shipping_fee: {
    including_postage: 1, cash_on_delivery: 2
  }

  enum shipping_method: {
    undecided: 1, easy_mercari: 2, yu_mail: 3, letter_pack: 4, regular_mail: 5, yamato_transport: 6, yu_pack: 7, click_post: 8, yu_pakcet: 9
  }

  enum shipping_from: {
    hokkaido: 1, aomori: 2, iwate: 3, miyagi: 4, akita: 5, yamagata: 6, fukushima: 7,
    ibaraki: 8, tochigi: 9, gunma: 10, saitama: 11, chiba: 12, tokyo: 13, kanagawa: 14,
    niigata: 15, toyama: 16, ishikawa: 17, fukui: 18, yamanashi: 19, nagano: 20,
    gifu: 21, shizuoka: 22, aichi: 23, mie: 24,
    shiga: 25, kyoto: 26, osaka: 27, hyogo: 28, nara: 29, wakayama: 30,
    tottori: 31, shimane: 32, okayama: 33, hiroshima: 34, yamaguchi: 35,
    tokushima: 36, kagawa: 37, ehime: 38, kochi: 39,
    fukuoka: 40, saga: 41, nagasaki: 42, kumamoto: 43, oita: 44, miyazaki: 45, kagoshima: 46, okinawa: 47
  }

  enum days_before_shipping: {
    in_two_days: 1, in_three_days: 2, in_seven_days: 3
  }

  validates :name,
    presence: true,
    length: { maximum: 40 }
  validates :price,
    numericality: { greater_than_or_equal_to: 300, less_than_or_equal_to: 9999999, message: "販売価格は300以上9,999,999以内で入力してください" }
  validates :description,
    presence: true,
    length: { maximum: 1000 }
  validates :condition,
    presence: { message: "選択して下さい" }
  validates :shipping_fee,
    presence: { message: "選択して下さい" }
  validates :shipping_from,
    presence: { message: "選択して下さい" }
  validates :days_before_shipping,
    presence: { message: "選択して下さい" }
  validates :shipping_method,
    presence: { message: "選択して下さい" }
  validates :status_id,
    presence: true
  validates :brand,
    length: { maximum: 40 }
  validates :category_id,
    numericality: { greater_than: 0, message: "選択して下さい" }
  validates :user_id,
    presence: true
  validates :size_id,
    numericality: { greater_than: 0, message: "選択して下さい" }

  scope :sort_update_desc, -> { order("updated_at DESC") }
  scope :get_next_item, -> (item) { where("id > ?", item.id).order("id ASC") }
  scope :get_previous_item, -> (item) { where("id < ?", item.id).order("id DESC") }
  scope :get_user_items, -> (item) { where(user_id: item.user_id).sort_update_desc }
  scope :get_category_items, -> (category_id) { where(category_id: category_id).sort_update_desc }

  # 検索用
  def self.sort_select_list
    [ ['価格の低い順', 'price ASC'], ['価格の高い順', 'price DESC'], ['出品の古い順', 'created_at ASC'], ['出品の新しい順', 'created_at DESC'], ['更新の古い順', 'updated_at ASC'], ['更新の新しい順（デフォルト）', 'updated_at DESC'] ]
  end

  def self.price_select_list
    ['300 ~ 1000', '1000 ~ 5000', '5000 ~ 10000', '10000 ~ 30000', '10000 ~ 30000', '50000 ~ ']
  end

  def self.condition_check_list
    { "0": 'すべて', "1": '新品、未使用', "2": '未使用に近い', "3": '目立った傷や汚れなし', "4": 'やや傷や汚れあり', "5": '傷や汚れあり', "6": '全体的に状態が悪い' }
  end

  def self.fee_check_list
    { "0": 'すべて', "1": '着払い(購入者負担)', "2": '送料込み(出品者負担)' }
  end

  def self.status_check_list
    { "0": 'すべて', "1": '販売中', "2,3": '売り切れ' }
  end

  # トップページアイテム取得
  def self.get_id_range(categories)
    start_id = categories.first.id
    end_id = categories.last.id
    Range.new(categories.first.id, categories.last.id)
  end

  def self.get_ladies
    categories = Category.find(1).grandchildren
    ladies = get_category_items(get_id_range(categories)).sort_update_desc
  end

  def self.get_mens
    categories = Category.find(2).grandchildren
    mens = get_category_items(get_id_range(categories)).sort_update_desc
  end

  def self.get_kids
    categories = Category.find(3).grandchildren
    kids = get_category_items(get_id_range(categories)).sort_update_desc
  end

  def self.get_cosme
    categories = Category.find(7).grandchildren
    cosme = get_category_items(get_id_range(categories)).sort_update_desc
  end

  def self.get_chanel
    chanel = Item.where(brand: 'シャネル').sort_update_desc
  end

  def self.get_louisvuitton
    louisvuitton = Item.where(brand: 'ルイ ヴィトン').sort_update_desc
  end

  def self.get_supreme
    supreme = Item.where(brand: 'シュプリーム').sort_update_desc
  end

  def self.get_nike
    nike = Item.where(brand: 'ナイキ').sort_update_desc
  end
end
