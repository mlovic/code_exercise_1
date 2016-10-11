I've implemented the rules basically as `Proc`s that take items and their prices as arguments. The `Proc` is wrapped in a `PricingRule` class that exposes an `apply_discount` method which returns the amount to be discounted. Apart from that there isn't any real abstraction here. I considered a few things like separating the discount condition from the amount calculation, and initializing rules for a specific item, but I thought it was all too restrictive for the little information given in the exercise.

Right now the PriceRule abstraction is very flexible however (the price rules are stateless and free of dependencies), and can be easily extended and built upon. For example by subclassing PricingRule. No code changes required:

<!--Right now the pricerule abstraction is completely separate from any checkout knowledge or product knowledge, so it's very flexible, although not very powerful. To improve this, one could subclass the RulePriceing-->

<!--With only a couple of simple rules, I didn't want to engineer it, but it would be easy to add more layers of abstraction by just subclassing PricingRule. No code changes required.-->

```ruby
class BuyXGetOneFree < PricingRule
  def initialize(item, x)
    @discount_fn = lambda do |items, prices|
      (items[item] / (x + 1)) * prices[item]
    end
  end
end

GREEN_TEA_PROMO = BuyXGetOneFree.new "GR1", 1
GREEN_TEA_PROMO.apply_discount items, prices
```

You just have to set the `@discount_fn` variable, which always holds a proc or a lambda.

I also considered making the discount function a method that could be overrided:
```ruby
class BuyXGetOneFree < PricingRule
  def discount(items, prices)
    # ...
```
However, PricingRule.new accepts a block for the discount function so I would have to keep an instance variable anyway.

### Why inheritance over composition?
I could have, for example, made `PricingRule` a module and mixed it in, but I think that it's more semantic this way. Everything truly is a PricingRule (it satisfies the Liskov substitution principle), so there's no reason not to. It also allows for multiple layers of inheritance. You can subclass the subclass:

  ```ruby
    class BuyXGetOneFreeWithMin < BuyXGetOneFree
      def initialize(item, x, min)
        bogof = super(item, x)
        @discount_fn = lambda do |items, prices|
          bogof.call if items.size > min # or something
        end
      end
    end
  ```

This looks like the beginning of an inheritance mess, but really it's just wrapping functions in functions.

Additionally, by making all rule objects instantiations of classes instead of classes that include modules, you can build them dynamically, from data pulled out of a database for example. 

### Why not just have a duck type? 
I also could have just adopted the convention of giving price rules an `apply_discount` method and forgot about any code sharing at all. There isn't much code to share after all. I realize this is often the best, cleanest, most rubylike approach, but I think that in this case, inheritance makes the "type" more explicit, and also makes the public interface easier to change, as it's only in one place.

I made the table of products just be a global constant directly read by `Checkout`. This conforms to the example, although it would have been cleaner and easier to test to pass the products table to the `Checkout` initializer.

The rest of the code is pretty straight forward. There are specs too!

A few other considerations, which I didn't implement:
 - Not using floating point numbers for prices
 - Marking pricing rules as exclusive, so as to disallow coumpounding multiple discounts for the same item. This could be handled outside the `Checkout` class.
