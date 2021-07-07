def find_item_by_name_in_collection(name, collection)
  result = nil
  collection.map do |elem|
    if elem[:item] == name
      result = elem
    end
  end
  result
end

def consolidate_cart(cart)
  new_hash = {}
  cart.map do |elem|
    if !new_hash[elem[:item]]
      new_hash[elem[:item]] = {
        :price => elem[:price],
        :clearance => elem[:clearance],
        :count => 1
      }
    elsif new_hash[elem[:item]]
      new_hash[elem[:item]][:count] += 1
    end
  end
  
  arr = []
  new_hash.each do |k, v|
    arr.push({
      :item => k,
      :price => v[:price],
      :clearance => v[:clearance],
      :count => v[:count]
    })
  end
  arr
end

def apply_coupons(cart, coupons)
  new_hash = {}
  cart.each do |cart_item|
    coupons.each do |coupon|
      if cart_item[:item] == coupon[:item]
        if cart_item[:count] >= coupon[:num] && cart_item[:item] != "#{cart_item[:item]} W/COUPON"
          cart.push({
            :item => "#{cart_item[:item]} W/COUPON",
            :price => coupon[:cost] / coupon[:num],
            :clearance => cart_item[:clearance],
            :count => coupon[:num]
          })
          cart_item[:count] -= coupon[:num]
        end
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.map do |cart_item|
    if cart_item[:clearance]
      cart_item[:price] -= cart_item[:price] * 0.2
    end
  end
  cart
end

def checkout(cart, coupons)
  applied_coupon = apply_coupons(consolidate_cart(cart), coupons)
  clearanced_cart = apply_clearance(applied_coupon)
  
  grand_total = 0
  clearanced_cart.map do |item|
    grand_total += item[:price] * item[:count]
  end

  if grand_total > 100
    return grand_total - (grand_total * 0.1)
  else
    return grand_total
  end
end
