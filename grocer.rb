# def find_item_by_name_in_collection(name, collection)
#   # Implement me first!
#   #
#   # Consult README for inputs and outputs
# end
#
# def consolidate_cart(cart)
#   # Consult README for inputs and outputs
#   #
#   # REMEMBER: This returns a new Array that represents the cart. Don't merely
#   # change `cart` (i.e. mutate) it. It's easier to return a new thing.
# end
#
# def apply_coupons(cart, coupons)
#   # Consult README for inputs and outputs
#   #
#   # REMEMBER: This method **should** update cart
# end
#
# def apply_clearance(cart)
#   # Consult README for inputs and outputs
#   #
#   # REMEMBER: This method **should** update cart
# end
#
# def checkout(cart, coupons)
#   # Consult README for inputs and outputs
#   #
#   # This method should call
#   # * consolidate_cart
#   # * apply_coupons
#   # * apply_clearance
#   #
#   # BEFORE it begins the work of calculating the total (or else you might have
#   # some irritated customers
# end
def find_item_by_name_in_collection (name, collection)
  search = {}
  collection.each do
    |cart_item|
    if cart_item[:item] == name
      return search = cart_item
    else
      search = nil
    end
  end
  search
end

def consolidate_cart(cart)  # AoH in, AoH out w/ no dupes.
  consol = cart.reduce([])  do
    |memo, item|
    existing_item = memo.find_index do
      |desired_product|
      desired_product[:item] == item[:item]
    end
    if existing_item
      memo[existing_item][:count] += 1
    else
      memo << item
      memo[-1][:count] = 1
    end
    memo
  end
end

def apply_coupons(cart, coupons)
  coupons.each do
    |coupon|
    existing_item = cart.find_index do
      |desired_product|
      desired_product[:item] == coupon[:item]
    end
    new_item = coupon[:item] + " W/COUPON"
    existing_coupon = cart.find_index do
      |desired_coupon|
      desired_coupon[:item] == new_item
    end

    if existing_item && cart[existing_item][:count] >= coupon[:num]
      if existing_coupon
        cart[existing_coupon][:count] += coupon[:num]
        cart[existing_item][:count] -= coupon[:num]
      else
        new_coup = {}
        new_coup[:item] = new_item
        new_coup[:count] = coupon[:num]
        new_coup[:clearance] = cart[existing_item][:clearance]
        new_coup[:price] = coupon[:cost]/coupon[:num]
        cart[existing_item][:count] -= coupon[:num]
        cart << new_coup
      end
    end
  end
  cart
end

def apply_clearance(cart)
  clearance_price = 0.80

  cleared_cart = cart.reduce([])  do
    |memo, item|
    memo << item
    if memo[-1][:clearance]
      memo[-1][:price] *= clearance_price
    end
    memo[-1][:price] = memo[-1][:price].round(2)
    memo
  end
  cleared_cart
end

def checkout(cart, coupons)
  discount_minimum = 100.00
  discount_price = 0.90

  consolidated = consolidate_cart(cart)
  couponed = apply_coupons(consolidated, coupons)
  cleared = apply_clearance(couponed)

  cart_total = cleared.reduce(0)  do
    |memo, item|
    memo += (item[:price] * item[:count])
    memo
  end
  if cart_total > discount_minimum
    cart_total *= discount_price
  end
  cart_total = cart_total.round(2)
  cart_total
end
