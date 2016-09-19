I've implemented the rules basically as `Proc`s that take items and their prices as arguments. The `Proc` are wrapped in a `PricingRule` class that exposes an `apply_discount` method which returns the amount to be discounted. Apart from that there isn't any real abstraction here. I considered a few things like separating the discount condition from the amount calculation, and initializing rules for a specific item, but I thought it was all too restrictive for the little information given in the exercise.

Right now the PriceRule abstraction is very flexible (the price rules are stateless and free of dependencies), and can be easily extended and built upon. For example by subclassing PricingRule, no code changes required.

<!--Right now the pricerule abstraction is completely separate from any checkout knowledge or product knowledge, so it's very flexible, although not very powerful. To improve this, one could subclass the RulePriceing-->

<!--With only a couple of simple rules, I didn't want to engineer it, but it would be easy to add more layers of abstraction by just subclassing PricingRule. No code changes required.-->

```ruby
class BuyXGetOneFree < PricingRule
  def initialize(item, x)
    @operation = lambda do |items, prices|
      (items[item] / (x + 1)) * prices[item]
    end
  end
end

VOUCHER_PROMO = BuyXGetOneFree.new "VOUCHER", 1
```

### Why inheritance over composition? Isn't that wrong?
I could have, for example, made `PricingRule` a module and mixed it in, but I think that it's more semantic this way. Everything truly is a PricingRule (it satisfies the Liskov substitution principle), so there's no reason not to. It also allows for multiple layers of inheritance. You can subclass the subclass:

  ```ruby
    class BuyXGetOneFreeWithMax < BuyXGetOneFree
      def initialize(item, x, max)
        op = super(item, x)
        @operation = lambda do |items, prices|
          op.call if items < 5
        end
      end
    end
  ```

This looks like the beginning of inheritance hell, but really it's just wrapping functions with functions, something very common in many languages.
Additionally, if you make all rules instantiations of classes instead of classes that include modules, you can build them dynamically, from data pulled out of a database for example. 

### Why not just have a duck type? 
I also could have just adopted the convention of giving price rules an `apply_discount` method and forgot about any code sharing at all. There isn't much code to share after all. I realize this is often the best, cleanest, most rubylike approach, but I think that in this case, inheritance makes the "type" more explicit, and also makes the public interface easier to change, as it's only in one place.


The rest of the code is pretty straight forward. There are specs too!
