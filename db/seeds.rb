# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' , { name: 'Lord of the Rings' ])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

User.destroy_all
Item.destroy_all
Order.destroy_all
OrderItem.destroy_all

item_images = ["https://www.sprinklesandsprouts.com/wp-content/uploads/2018/05/Prosciutto-and-Ricotta-Hors-doeuvres1.jpg",
              "http://www.happyfoodstube.com/wp-content/uploads/2017/01/Anchovy-Hors-d-Oeuvres.jpg",
              "https://www.craftycookingmama.com/wp-content/uploads/2016/11/097.jpg",
              "https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/Ringier_175_Jahre_Jubil%C3%A4um_%282499873203%29_%282%29.jpg/220px-Ringier_175_Jahre_Jubil%C3%A4um_%282499873203%29_%282%29.jpg",
              "http://www.naturesownbread.com/sites/default/files/styles/recipe_page/public/images/recipe/main/Italian%20Caprese%20Hors%20d%27Oeuvres_460x310.jpg?itok=9nDTjIp1&timestamp=1461272865",
              "https://food.fnr.sndimg.com/content/dam/images/food/fullset/2010/5/18/0/0039996F4_Abalone-Hors-doeuvres_s4x3.jpg.rend.hgtvcom.826.620.suffix/1371592942848.jpeg",
              "https://mcleanmeats.com/wp-content/uploads/2017/04/MCLEAN-HAM-CHEESE-HORS-DOEUVRES.jpg",
              "https://www.seasonsandsuppers.ca/wp-content/uploads/2016/11/watermelon-appetizers1-1170x780.jpg",
              "https://www.thespruceeats.com/thmb/u_wiPrwW7zyE-TpYbsoaiImluJ4=/450x0/filters:no_upscale():max_bytes(150000):strip_icc()/scallop-tartare-winter-citrus-on-spoon-142941132-5827a4f33df78c6f6a540871.jpg",
              "https://www.mackenzieltd.com/media/catalog/product/cache/1/image/720x/9d8c13ad2e311836456e095f4b3deb82/d/p/dpn12_1.jpg",
              "http://barillafoodservicerecipes.com/wp-content/uploads/2014/09/Mezzi-Rigatoni-With-Ricotta-Cheese-And-Spinach-Filling.jpg",
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkUsmy0-la-2i2gHIHVksNggCTNhus2WTLAYxQvjCRj6n-rbXE",
              "https://thumbor.thedailymeal.com/HijgBWIJly7Q_heco0lbx-bKE0U=/840x565/filters:focal(420x282:421x283)/https://www.thedailymeal.com/sites/default/files/story/2017/Sriracha%20Deviled%20Eggs%20With%20Candied%20Bacon%20McCormick.jpg",
              "https://res.cloudinary.com/jerrick/image/upload/f_auto,fl_progressive,q_auto,c_fit,w_1100/svgtt6p2kk4qscqjd826",
              "https://food.fnr.sndimg.com/content/dam/images/food/fullset/2013/1/23/1/YW0207H_Sausage-hors-d-oeuves_s4x3.jpg.rend.hgtvcom.616.462.suffix/1412781004766.jpeg",
              "http://www.taste-food.com/newsite/wp-content/uploads/hors_doeuvres_header.jpg",
              "http://vibranttable.com/wp-content/uploads/2015/04/feat-hdos-2.jpg",
              "https://www.tasteofhome.com/wp-content/uploads/2017/09/exps186693_SD153319B10_14_3b-696x696.jpg",
              "https://imagesvc.timeincapp.com/v3/mm/image?url=https%3A%2F%2Fcdn-image.foodandwine.com%2Fsites%2Fdefault%2Ffiles%2Fhd-201402-r-crostini-with-roasted-butternut-squash-ricotta-and-preserved-lemon.jpg&w=450&c=sc&poi=face&q=85",
              "https://assets.marthastewartweddings.com/styles/wmax-520-highdpi/d21/mwd103584_spr08_beets/mwd103584_spr08_beets_xl.jpg?itok=uOT2k2cs",
              "http://www.bigchefonline.com/v/vspfiles/assets/images/appetizer-hors-d'oeuvres.png",
              "http://www.pamelasproducts.com/wp-content/uploads/2012/08/Cheese-Puff-Pastry-Cups-1024x685.jpg",
              "https://secure.auifinefoods.com/img/category/14_Hors-d'Oeuvres_American.jpg",
              "https://nantucketanglersclub.com/wp-content/uploads/hors-d-oeuvres-home-white-14911.jpg",
              "https://ii.worldmarket.com/fcgi-bin/iipsrv.fcgi?FIF=/images/worldmarket/source/63120_XXX_v1.tif&qlt=75&wid=315&cvt=jpeg",
              "http://www.pamelasproducts.com/wp-content/uploads/2012/08/Cheese-Puff-Pastry-Rounds-1024x685.jpg",
              "https://www.dairygoodness.ca/var/ezflow_site/storage/images/plaisirs-laitiers/accueil/recettes/poires-au-miel-gratinees-au-four/14281241-1-eng-CA/pears-with-cheese-honey_medium.jpg",
              "https://www.eatlivetravelwrite.com/wp-content/uploads/2010/12/pumpkin-cornbread-cubes-FG.jpg",
              "https://images.food52.com/mfL8kkmNME9yDpw8N5s0C5XkVWY=/7a1f55cc-84c7-4d07-9d43-cb6677740ff1--16062488886_a4afe1d131_b.jpg",
              "https://www.sunrisebistrocatering.com/sites/default/files/aram-sandwiches.jpg",
              "https://www.dairygoodness.ca/var/ezflow_site/storage/images/dairy-goodness/home/recipes/oysters-au-gratin/14216355-1-eng-CA/oysters-au-gratin_medium.jpg",
              "http://www.debutbyjuancarlo.com.ph/wp-content/uploads/2015/02/Hors-d%E2%80%99oeuvres1.jpg",
              "https://www.williams-sonoma.com/wsimgs/ab/images/dp/recipe/201849/0012/img17.jpg",
              "https://s3.amazonaws.com/finecooking.s3.tauntonclud.com/app/uploads/2017/04/19004013/fc69qd002-01-main.jpg",
              "https://static1.squarespace.com/static/59b8347bbce1767c37764999/t/5ace4cee88251ba3fcdc5fbf/1523469558589/oneworld_2018_dishes_0007.jpg",
              "https://imagesvc.timeincapp.com/v3/mm/image?url=https%3A%2F%2Fcdn-image.foodandwine.com%2Fsites%2Fdefault%2Ffiles%2FHD-201012-r-crab-avocado-toasts.jpg&w=450&c=sc&poi=face&q=85",
              "http://www.cateringbymichaels.com/wp-content/uploads/Spring-Pea-Risotto-Cake.jpeg",
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT74CqDH_5dvaFOjCWCRihZPlGQyJGmTTw6hrT0uS4A9UGEfEwr",
              "https://groovingourmets.com/wp-content/uploads/2015/11/hors-article-picture.jpg",
              "https://www.beekman1802.com/wp-content/uploads/2009/06/img_5736-550x412.jpg",
              "https://www.williams-sonoma.com/wsimgs/ab/images/dp/wcm/201849/0202/img57j.jpg",
              "https://static1.squarespace.com/static/56bfa255e707eb2069451dfe/t/56ca48463c44d834793a37a2/1456097364466/",
              "https://hips.hearstapps.com/clv.h-cdn.co/assets/cm/15/09/480x552/54ead91fee016_-_wrapped-asparagus-balsamic-dipping-sauce-recipe-clv0413-xln.jpg",
              "https://static1.squarespace.com/static/56bfa255e707eb2069451dfe/t/56c8d0decf80a13fe9f92fa6/1456001255592/",
              "https://thumbor.thedailymeal.com/nxecMGiRWxjvvAZR4DoLzFPLXQ4=/840x565/https://www.thedailymeal.com/sites/default/files/2014/09/10/246642517064565999_tgomaxuv_c-001.jpg",
              "https://www.seriouseats.com/recipes/images/2017/01/20150127-buffalo-wings-oven-fried-7-625x469.jpg",
              "https://i.pinimg.com/originals/2b/ab/56/2bab56b00a2d6bf253a8f9e2813b1b66.jpg",
              "http://www.vibranttable.com/wp-content/uploads/2012/12/blog-square-pic-veggies.jpg",
              "http://www.smokeandspice.com/site/wp-content/uploads/2012/03/Dessert1.jpg",
              "http://www.voila-catering.com/wp-content/grand-media/image/threehds.jpg",
              "https://cdn-image.foodandwine.com/sites/default/files/HD-200807-r-pancetta-peaches.jpg",
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDc_wjbkQduSUV6O8uXF3I86q8tsMYfE5lU0KbsCMy5wBoB6E1",
              "https://www.dairygoodness.ca/var/ezflow_site/storage/images/dairy-goodness/home/recipes/cream-cheese-prosciutto-cocktail-bites/14282147-1-eng-CA/cream-cheese-prosciutto-cocktail-bites.jpg",
              "https://ii.worldmarket.com/fcgi-bin/iipsrv.fcgi?FIF=/images/worldmarket/source/63119_XXX_v1.tif&qlt=75&wid=315&cvt=jpeg"
              ]

all_merchants = []
8.times do
  name = Faker::Name.name
  street_address = Faker::Address.street_address
  city = Faker::Address.city
  state = Faker::Address.state
  zip_code = Faker::Address.zip
  email = Faker::Internet.unique.email
  password = 'password'
  role = 1
  activation_status = 0
  user = User.create(name: name, street_address: street_address, city: city, state: state, zip_code: zip_code, email: email, role: role, password: password, activation_status: activation_status)
  all_merchants << user
  6.times do
    title = Faker::Food.unique.dish
    description = Faker::Food.description
    quantity = Faker::Number.number(4)
    price = Faker::Commerce.price
    active = true
    image_url = item_images.sample
    user.items.create(title: title, description: description, quantity: quantity, price: price, image_url: image_url, active: active)
  end
end

name = 'test merchant'
street_address = Faker::Address.street_address
city = Faker::Address.city
state = Faker::Address.state
zip_code = Faker::Address.zip
email = 'merchant@test.com'
password = 'password'
role = 1
activation_status = 0
user = User.create!(name: name, street_address: street_address, city: city, state: state, zip_code: zip_code, email: email, role: role, password: password, activation_status: activation_status)
all_merchants << user
6.times do
  title = Faker::Food.unique.dish
  description = Faker::Food.description
  quantity = Faker::Number.number(4)
  price = Faker::Commerce.price
  active = true
  user.items.create(title: title, description: description, quantity: quantity, price: price, active: active)
end

10.times do
  name = Faker::Name.name
  street_address = Faker::Address.street_address
  city = Faker::Address.city
  state = Faker::Address.state
  zip_code = Faker::Address.zip
  email = Faker::Internet.unique.email
  password = 'password'
  role = 0
  status = 0
  user = User.create!(name: name, street_address: street_address, city: city, state: state, zip_code: zip_code, email: email, role: role, password: password, activation_status: activation_status)
  rand(1..8).times do
    status = [0, 1].sample
    created_at = rand(300..500).days.ago
    updated_at = rand(100..299).days.ago

    order = user.orders.create!(status: status, created_at: created_at, updated_at: updated_at)
    rand(1..5).times do
      item = all_merchants.sample.items.sample
      activation_status = 0
      OrderItem.create!(order: order, item: item, sale_price: item.price, quantity: rand(1..10))
    end
  end
end

name = 'test user'
street_address = Faker::Address.street_address
city = Faker::Address.city
state = Faker::Address.state
zip_code = Faker::Address.zip
email = 'user@test.com'
password = 'password'
role = 0
activation_status = 0
User.create!(name: name, street_address: street_address, city: city, state: state, zip_code: zip_code, email: email, role: role, password: password, activation_status: activation_status)
rand(1..8).times do
  status = [0, 1].sample
  created_at = rand(300..500).days.ago
  updated_at = rand(100..299).days.ago

  order = user.orders.create!(status: status, created_at: created_at, updated_at: updated_at)
  rand(1..5).times do
    item = all_merchants.sample.items.sample
    activation_status = 0
    OrderItem.create!(order: order, item: item, sale_price: item.price, quantity: rand(1..10))
  end
end

name = 'test admin'
street_address = Faker::Address.street_address
city = Faker::Address.city
state = Faker::Address.state
zip_code = Faker::Address.zip
email = 'admin@test.com'
password = 'password'
role = 2
activation_status = 0
User.create!(name: name, street_address: street_address, city: city, state: state, zip_code: zip_code, email: email, role: role, password: password, activation_status: activation_status)

user_names = "List of user logins\n\n"
User.all.each do |any_user|
  user_names += "User: Role: #{any_user.role}, Email: #{any_user.email}, password: 'password'\n"
end

file_path = './db/user_login_credentials.txt'
File.open(file_path, 'w') { |file| file.write(user_names) }
