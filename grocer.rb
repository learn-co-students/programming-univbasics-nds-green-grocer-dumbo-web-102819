def find_item_by_name_in_collection(name, collection)
  temp_hash = Hash.new
  temp_hash = nil
  index = 0
  while index < collection.size do
    if name == collection[index][:item]
      temp_hash = collection[index]
    end
    index += 1
  end
  temp_hash
  # Implement me first!
  #
  # Consult README for inputs and outputs
end

def consolidate_cart(cart)
  temp_cart = Array.new
  temp_hash = Hash.new
  index_1 = 0
  while index_1 < cart.size do
    item_name = cart[index_1][:item]
    index_2 = 0
    already_in_cart = false
    while index_2 < temp_cart.size do
      if temp_cart[index_2][:item] == item_name
        temp_cart[index_2][:count] += 1
        already_in_cart = true
      end
      index_2 += 1
    end
    if !already_in_cart
      temp_hash = cart[index_1]
      temp_hash[:count] = 1
      temp_cart << temp_hash
    end
    index_1 += 1
  end
  temp_cart
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
end

def apply_coupons(cart, coupons)
  index_cart = 0
  while index_cart < cart.size do
    index_coupons = 0
    while index_coupons < coupons.size do
      if (cart[index_cart][:item] == coupons[index_coupons][:item]) && (cart[index_cart][:count] >= coupons[index_coupons][:num])
        coupon_count = cart[index_cart][:count] / coupons[index_coupons][:num]
        remainder = cart[index_cart][:count] % coupons[index_coupons][:num]
        item_name = coupons[index_coupons][:item]
        temp_hash = Hash.new
        temp_hash[:item] = "#{item_name} W/COUPON"
        temp_hash[:price] = (coupons[index_coupons][:cost] / coupons[index_coupons][:num]).round(2)
        temp_hash[:clearance] = cart[index_cart][:clearance]
        temp_hash[:count] = coupon_count.to_i * coupons[index_coupons][:num].to_i
        cart << temp_hash
        cart[index_cart][:count] = remainder
      end
      index_coupons += 1
    end
    index_cart += 1
  end
  cart
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
end

def apply_clearance(cart)
  index = 0
  while index < cart.size do
    if cart[index][:clearance]
      cart[index][:price] = (cart[index][:price] * 0.80).round(2)
    end
    index += 1
  end
  cart
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  index = 0
  subtotal = 0
  while index < cart.size do
    item_total_price = cart[index][:price] * cart[index][:count]
    subtotal += item_total_price
    index += 1
  end
  if subtotal > 100
    subtotal = (subtotal * 0.90).round(2)
  end
  subtotal
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers
end
