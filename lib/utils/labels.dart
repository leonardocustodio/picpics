import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/providers/language_provider.dart';

class PredefinedLabels {
  static String labelTranslation(String label, WidgetRef ref) {
    final s = ref.read(sProvider);
    switch (label) {
      case 'Team':
        return s.team_tag;

      case 'Bonfire':
        return s.bonfire_tag;

      case 'Comics':
        return s.comics_tag;

      case 'Himalayan':
        return s.himalayan_tag;

      case 'Iceberg':
        return s.iceberg_tag;

      case 'Bento':
        return s.bento_tag;

      case 'Sink':
        return s.sink_tag;

      case 'Toy':
        return s.toy_tag;

      case 'Statue':
        return s.statue_tag;

      case 'Cheeseburger':
        return s.cheeseburger_tag;

      case 'Tractor':
        return s.tractor_tag;

      case 'Sled':
        return s.sled_tag;

      case 'Aquarium':
        return s.aquarium_tag;

      case 'Circus':
        return s.circus_tag;

      case 'Sitting':
        return s.sitting_tag;

      case 'Beard':
        return s.beard_tag;

      case 'Bridge':
        return s.bridge_tag;

      case 'Tights':
        return s.tights_tag;

      case 'Bird':
        return s.bird_tag;

      case 'Rafting':
        return s.rafting_tag;

      case 'Park':
        return s.park_tag;

      case 'Factory':
        return s.factory_tag;

      case 'Graduation':
        return s.graduation_tag;

      case 'Porcelain':
        return s.porcelain_tag;

      case 'Twig':
        return s.twig_tag;

      case 'Petal':
        return s.petal_tag;

      case 'Cushion':
        return s.cushion_tag;

      case 'Sunglasses':
        return s.sunglasses_tag;

      case 'Infrastructure':
        return s.infrastructure_tag;

      case 'Ferris wheel':
        return s.ferris_wheel_tag;

      case 'Pomacentridae':
        return s.pomacentridae_tag;

      case 'Wetsuit':
        return s.wetsuit_tag;

      case 'Shetland sheepdog':
        return s.shetland_sheepdog_tag;

      case 'Brig':
        return s.brig_tag;

      case 'Watercolor paint':
        return s.watercolor_paint_tag;

      case 'Competition':
        return s.competition_tag;

      case 'Cliff':
        return s.cliff_tag;

      case 'Badminton':
        return s.badminton_tag;

      case 'Safari':
        return s.safari_tag;

      case 'Bicycle':
        return s.bicycle_tag;

      case 'Stadium':
        return s.stadium_tag;

      case 'Boat':
        return s.boat_tag;

      case 'Smile':
        return s.smile_tag;

      case 'Surfboard':
        return s.surfboard_tag;

      case 'Fast food':
        return s.fast_food_tag;

      case 'Sunset':
        return s.sunset_tag;

      case 'Hot dog':
        return s.hot_dog_tag;

      case 'Shorts':
        return s.shorts_tag;

      case 'Bus':
        return s.bus_tag;

      case 'Bullfighting':
        return s.bullfighting_tag;

      case 'Sky':
        return s.sky_tag;

      case 'Gerbil':
        return s.gerbil_tag;

      case 'Rock':
        return s.rock_tag;

      case 'Interaction':
        return s.interaction_tag;

      case 'Dress':
        return s.dress_tag;

      case 'Toe':
        return s.toe_tag;

      case 'Bear':
        return s.bear_tag;

      case 'Eating':
        return s.eating_tag;

      case 'Tower':
        return s.tower_tag;

      case 'Brick':
        return s.brick_tag;

      case 'Junk':
        return s.junk_tag;

      case 'Person':
        return s.person_tag;

      case 'Windsurfing':
        return s.windsurfing_tag;

      case 'Swimwear':
        return s.swimwear_tag;

      case 'Roller':
        return s.roller_tag;

      case 'Camping':
        return s.camping_tag;

      case 'Playground':
        return s.playground_tag;

      case 'Bathroom':
        return s.bathroom_tag;

      case 'Laugh':
        return s.laugh_tag;

      case 'Balloon':
        return s.balloon_tag;

      case 'Concert':
        return s.concert_tag;

      case 'Prom':
        return s.prom_tag;

      case 'Construction':
        return s.construction_tag;

      case 'Product':
        return s.product_tag;

      case 'Reef':
        return s.reef_tag;

      case 'Picnic':
        return s.picnic_tag;

      case 'Wreath':
        return s.wreath_tag;

      case 'Wheelbarrow':
        return s.wheelbarrow_tag;

      case 'Boxer':
        return s.boxer_tag;

      case 'Necklace':
        return s.necklace_tag;

      case 'Bracelet':
        return s.bracelet_tag;

      case 'Casino':
        return s.casino_tag;

      case 'Windshield':
        return s.windshield_tag;

      case 'Stairs':
        return s.stairs_tag;

      case 'Computer':
        return s.computer_tag;

      case 'Cookware and bakeware':
        return s.cookware_and_bakeware_tag;

      case 'Monochrome':
        return s.monochrome_tag;

      case 'Chair':
        return s.chair_tag;

      case 'Poster':
        return s.poster_tag;

      case 'Bar':
        return s.bar_tag;

      case 'Shipwreck':
        return s.shipwreck_tag;

      case 'Pier':
        return s.pier_tag;

      case 'Community':
        return s.community_tag;

      case 'Caving':
        return s.caving_tag;

      case 'Cave':
        return s.cave_tag;

      case 'Tie':
        return s.tie_tag;

      case 'Cabinetry':
        return s.cabinetry_tag;

      case 'Underwater':
        return s.underwater_tag;

      case 'Clown':
        return s.clown_tag;

      case 'Nightclub':
        return s.nightclub_tag;

      case 'Cycling':
        return s.cycling_tag;

      case 'Comet':
        return s.comet_tag;

      case 'Mortarboard':
        return s.mortarboard_tag;

      case 'Track':
        return s.track_tag;

      case 'Christmas':
        return s.christmas_tag;

      case 'Church':
        return s.church_tag;

      case 'Clock':
        return s.clock_tag;

      case 'Dude':
        return s.dude_tag;

      case 'Cattle':
        return s.cattle_tag;

      case 'Jungle':
        return s.jungle_tag;

      case 'Desk':
        return s.desk_tag;

      case 'Curling':
        return s.curling_tag;

      case 'Cuisine':
        return s.cuisine_tag;

      case 'Cat':
        return s.cat_tag;

      case 'Juice':
        return s.juice_tag;

      case 'Couscous':
        return s.couscous_tag;

      case 'Screenshot':
        return s.screenshot_tag;

      case 'Crew':
        return s.crew_tag;

      case 'Skyline':
        return s.skyline_tag;

      case 'Stuffed toy':
        return s.stuffed_toy_tag;

      case 'Cookie':
        return s.cookie_tag;

      case 'Tile':
        return s.tile_tag;

      case 'Hanukkah':
        return s.hanukkah_tag;

      case 'Crochet':
        return s.crochet_tag;

      case 'Skateboarder':
        return s.skateboarder_tag;

      case 'Clipper':
        return s.clipper_tag;

      case 'Nail':
        return s.nail_tag;

      case 'Cola':
        return s.cola_tag;

      case 'Cutlery':
        return s.cutlery_tag;

      case 'Menu':
        return s.menu_tag;

      case 'Sari':
        return s.sari_tag;

      case 'Plush':
        return s.plush_tag;

      case 'Pocket':
        return s.pocket_tag;

      case 'Neon':
        return s.neon_tag;

      case 'Icicle':
        return s.icicle_tag;

      case 'Pasteles':
        return s.pasteles_tag;

      case 'Chain':
        return s.chain_tag;

      case 'Dance':
        return s.dance_tag;

      case 'Dune':
        return s.dune_tag;

      case 'Santa claus':
        return s.santa_claus_tag;

      case 'Thanksgiving':
        return s.thanksgiving_tag;

      case 'Tuxedo':
        return s.tuxedo_tag;

      case 'Mouth':
        return s.mouth_tag;

      case 'Desert':
        return s.desert_tag;

      case 'Dinosaur':
        return s.dinosaur_tag;

      case 'Mufti':
        return s.mufti_tag;

      case 'Fire':
        return s.fire_tag;

      case 'Bedroom':
        return s.bedroom_tag;

      case 'Goggles':
        return s.goggles_tag;

      case 'Dragon':
        return s.dragon_tag;

      case 'Couch':
        return s.couch_tag;

      case 'Sledding':
        return s.sledding_tag;

      case 'Cap':
        return s.cap_tag;

      case 'Whiteboard':
        return s.whiteboard_tag;

      case 'Hat':
        return s.hat_tag;

      case 'Gelato':
        return s.gelato_tag;

      case 'Cavalier':
        return s.cavalier_tag;

      case 'Beanie':
        return s.beanie_tag;

      case 'Jersey':
        return s.jersey_tag;

      case 'Scarf':
        return s.scarf_tag;

      case 'Vacation':
        return s.vacation_tag;

      case 'Pitch':
        return s.pitch_tag;

      case 'Blackboard':
        return s.blackboard_tag;

      case 'Deejay':
        return s.deejay_tag;

      case 'Monument':
        return s.monument_tag;

      case 'Bumper':
        return s.bumper_tag;

      case 'Longboard':
        return s.longboard_tag;

      case 'Waterfowl':
        return s.waterfowl_tag;

      case 'Flesh':
        return s.flesh_tag;

      case 'Net':
        return s.net_tag;

      case 'Icing':
        return s.icing_tag;

      case 'Dalmatian':
        return s.dalmatian_tag;

      case 'Speedboat':
        return s.speedboat_tag;

      case 'Trunk':
        return s.trunk_tag;

      case 'Coffee':
        return s.coffee_tag;

      case 'Soccer':
        return s.soccer_tag;

      case 'Ragdoll':
        return s.ragdoll_tag;

      case 'Food':
        return s.food_tag;

      case 'Standing':
        return s.standing_tag;

      case 'Fiction':
        return s.fiction_tag;

      case 'Fruit':
        return s.fruit_tag;

      case 'Pho':
        return s.pho_tag;

      case 'Sparkler':
        return s.sparkler_tag;

      case 'Presentation':
        return s.presentation_tag;

      case 'Swing':
        return s.swing_tag;

      case 'Cairn terrier':
        return s.cairn_terrier_tag;

      case 'Forest':
        return s.forest_tag;

      case 'Flag':
        return s.flag_tag;

      case 'Frigate':
        return s.frigate_tag;

      case 'Foot':
        return s.foot_tag;

      case 'Jacket':
        return s.jacket_tag;

      case 'Pillow':
        return s.pillow_tag;

      case 'Bathing':
        return s.bathing_tag;

      case 'Glacier':
        return s.glacier_tag;

      case 'Gymnastics':
        return s.gymnastics_tag;

      case 'Ear':
        return s.ear_tag;

      case 'Flora':
        return s.flora_tag;

      case 'Shell':
        return s.shell_tag;

      case 'Grandparent':
        return s.grandparent_tag;

      case 'Ruins':
        return s.ruins_tag;

      case 'Eyelash':
        return s.eyelash_tag;

      case 'Bunk bed':
        return s.bunk_bed_tag;

      case 'Balance':
        return s.balance_tag;

      case 'Backpacking':
        return s.backpacking_tag;

      case 'Horse':
        return s.horse_tag;

      case 'Glitter':
        return s.glitter_tag;

      case 'Saucer':
        return s.saucer_tag;

      case 'Hair':
        return s.hair_tag;

      case 'Miniature':
        return s.miniature_tag;

      case 'Crowd':
        return s.crowd_tag;

      case 'Curtain':
        return s.curtain_tag;

      case 'Icon':
        return s.icon_tag;

      case 'Pixie-bob':
        return s.pixie_bob_tag;

      case 'Herd':
        return s.herd_tag;

      case 'Insect':
        return s.insect_tag;

      case 'Ice':
        return s.ice_tag;

      case 'Bangle':
        return s.bangle_tag;

      case 'Flap':
        return s.flap_tag;

      case 'Jewellery':
        return s.jewellery_tag;

      case 'Knitting':
        return s.knitting_tag;

      case 'Centrepiece':
        return s.centrepiece_tag;

      case 'Outerwear':
        return s.outerwear_tag;

      case 'Love':
        return s.love_tag;

      case 'Muscle':
        return s.muscle_tag;

      case 'Motorcycle':
        return s.motorcycle_tag;

      case 'Money':
        return s.money_tag;

      case 'Mosque':
        return s.mosque_tag;

      case 'Tableware':
        return s.tableware_tag;

      case 'Ballroom':
        return s.ballroom_tag;

      case 'Kayak':
        return s.kayak_tag;

      case 'Leisure':
        return s.leisure_tag;

      case 'Receipt':
        return s.receipt_tag;

      case 'Lake':
        return s.lake_tag;

      case 'Lighthouse':
        return s.lighthouse_tag;

      case 'Bridle':
        return s.bridle_tag;

      case 'Leather':
        return s.leather_tag;

      case 'Horn':
        return s.horn_tag;

      case 'Strap':
        return s.strap_tag;

      case 'Lego':
        return s.lego_tag;

      case 'Scuba diving':
        return s.scuba_diving_tag;

      case 'Leggings':
        return s.leggings_tag;

      case 'Pool':
        return s.pool_tag;

      case 'Musical instrument':
        return s.musical_instrument_tag;

      case 'Musical':
        return s.musical_tag;

      case 'Metal':
        return s.metal_tag;

      case 'Moon':
        return s.moon_tag;

      case 'Blazer':
        return s.blazer_tag;

      case 'Marriage':
        return s.marriage_tag;

      case 'Mobile phone':
        return s.mobile_phone_tag;

      case 'Militia':
        return s.militia_tag;

      case 'Tablecloth':
        return s.tablecloth_tag;

      case 'Party':
        return s.party_tag;

      case 'Nebula':
        return s.nebula_tag;

      case 'News':
        return s.news_tag;

      case 'Newspaper':
        return s.newspaper_tag;

      case 'Piano':
        return s.piano_tag;

      case 'Plant':
        return s.plant_tag;

      case 'Passport':
        return s.passport_tag;

      case 'Penguin':
        return s.penguin_tag;

      case 'Shikoku':
        return s.shikoku_tag;

      case 'Palace':
        return s.palace_tag;

      case 'Doily':
        return s.doily_tag;

      case 'Polo':
        return s.polo_tag;

      case 'Paper':
        return s.paper_tag;

      case 'Pop music':
        return s.pop_music_tag;

      case 'Skiff':
        return s.skiff_tag;

      case 'Pizza':
        return s.pizza_tag;

      case 'Pet':
        return s.pet_tag;

      case 'Quilting':
        return s.quilting_tag;

      case 'Cage':
        return s.cage_tag;

      case 'Skateboard':
        return s.skateboard_tag;

      case 'Surfing':
        return s.surfing_tag;

      case 'Rugby':
        return s.rugby_tag;

      case 'Lipstick':
        return s.lipstick_tag;

      case 'River':
        return s.river_tag;

      case 'Race':
        return s.race_tag;

      case 'Rowing':
        return s.rowing_tag;

      case 'Road':
        return s.road_tag;

      case 'Running':
        return s.running_tag;

      case 'Room':
        return s.room_tag;

      case 'Roof':
        return s.roof_tag;

      case 'Star':
        return s.star_tag;

      case 'Sports':
        return s.sports_tag;

      case 'Shoe':
        return s.shoe_tag;

      case 'Tubing':
        return s.tubing_tag;

      case 'Space':
        return s.space_tag;

      case 'Sleep':
        return s.sleep_tag;

      case 'Skin':
        return s.skin_tag;

      case 'Swimming':
        return s.swimming_tag;

      case 'School':
        return s.school_tag;

      case 'Sushi':
        return s.sushi_tag;

      case 'Loveseat':
        return s.loveseat_tag;

      case 'Superman':
        return s.superman_tag;

      case 'Cool':
        return s.cool_tag;

      case 'Skiing':
        return s.skiing_tag;

      case 'Submarine':
        return s.submarine_tag;

      case 'Song':
        return s.song_tag;

      case 'Class':
        return s.class_tag;

      case 'Skyscraper':
        return s.skyscraper_tag;

      case 'Volcano':
        return s.volcano_tag;

      case 'Television':
        return s.television_tag;

      case 'Rein':
        return s.rein_tag;

      case 'Tattoo':
        return s.tattoo_tag;

      case 'Train':
        return s.train_tag;

      case 'Handrail':
        return s.handrail_tag;

      case 'Cup':
        return s.cup_tag;

      case 'Vehicle':
        return s.vehicle_tag;

      case 'Handbag':
        return s.handbag_tag;

      case 'Lampshade':
        return s.lampshade_tag;

      case 'Event':
        return s.event_tag;

      case 'Wine':
        return s.wine_tag;

      case 'Wing':
        return s.wing_tag;

      case 'Wheel':
        return s.wheel_tag;

      case 'Wakeboarding':
        return s.wakeboarding_tag;

      case 'Web page':
        return s.web_page_tag;

      case 'Ranch':
        return s.ranch_tag;

      case 'Fishing':
        return s.fishing_tag;

      case 'Heart':
        return s.heart_tag;

      case 'Cotton':
        return s.cotton_tag;

      case 'Cappuccino':
        return s.cappuccino_tag;

      case 'Bread':
        return s.bread_tag;

      case 'Sand':
        return s.sand_tag;

      case 'Museum':
        return s.museum_tag;

      case 'Helicopter':
        return s.helicopter_tag;

      case 'Mountain':
        return s.mountain_tag;

      case 'Duck':
        return s.duck_tag;

      case 'Soil':
        return s.soil_tag;

      case 'Turtle':
        return s.turtle_tag;

      case 'Crocodile':
        return s.crocodile_tag;

      case 'Musician':
        return s.musician_tag;

      case 'Sneakers':
        return s.sneakers_tag;

      case 'Wool':
        return s.wool_tag;

      case 'Ring':
        return s.ring_tag;

      case 'Singer':
        return s.singer_tag;

      case 'Carnival':
        return s.carnival_tag;

      case 'Snowboarding':
        return s.snowboarding_tag;

      case 'Waterskiing':
        return s.waterskiing_tag;

      case 'Wall':
        return s.wall_tag;

      case 'Rocket':
        return s.rocket_tag;

      case 'Countertop':
        return s.countertop_tag;

      case 'Beach':
        return s.beach_tag;

      case 'Rainbow':
        return s.rainbow_tag;

      case 'Branch':
        return s.branch_tag;

      case 'Moustache':
        return s.moustache_tag;

      case 'Garden':
        return s.garden_tag;

      case 'Gown':
        return s.gown_tag;

      case 'Field':
        return s.field_tag;

      case 'Dog':
        return s.dog_tag;

      case 'Superhero':
        return s.superhero_tag;

      case 'Flower':
        return s.flower_tag;

      case 'Placemat':
        return s.placemat_tag;

      case 'Subwoofer':
        return s.subwoofer_tag;

      case 'Cathedral':
        return s.cathedral_tag;

      case 'Building':
        return s.building_tag;

      case 'Airplane':
        return s.airplane_tag;

      case 'Fur':
        return s.fur_tag;

      case 'Bull':
        return s.bull_tag;

      case 'Bench':
        return s.bench_tag;

      case 'Temple':
        return s.temple_tag;

      case 'Butterfly':
        return s.butterfly_tag;

      case 'Model':
        return s.model_tag;

      case 'Marathon':
        return s.marathon_tag;

      case 'Needlework':
        return s.needlework_tag;

      case 'Kitchen':
        return s.kitchen_tag;

      case 'Castle':
        return s.castle_tag;

      case 'Aurora':
        return s.aurora_tag;

      case 'Larva':
        return s.larva_tag;

      case 'Racing':
        return s.racing_tag;

      case 'Airliner':
        return s.airliner_tag;

      case 'Dam':
        return s.dam_tag;

      case 'Textile':
        return s.textile_tag;

      case 'Groom':
        return s.groom_tag;

      case 'Fun':
        return s.fun_tag;

      case 'Steaming':
        return s.steaming_tag;

      case 'Vegetable':
        return s.vegetable_tag;

      case 'Unicycle':
        return s.unicycle_tag;

      case 'Jeans':
        return s.jeans_tag;

      case 'Flowerpot':
        return s.flowerpot_tag;

      case 'Drawer':
        return s.drawer_tag;

      case 'Cake':
        return s.cake_tag;

      case 'Armrest':
        return s.armrest_tag;

      case 'Aviation':
        return s.aviation_tag;

      case 'Fog':
        return s.fog_tag;

      case 'Fireworks':
        return s.fireworks_tag;

      case 'Farm':
        return s.farm_tag;

      case 'Seal':
        return s.seal_tag;

      case 'Shelf':
        return s.shelf_tag;

      case 'Bangs':
        return s.bangs_tag;

      case 'Lightning':
        return s.lightning_tag;

      case 'Van':
        return s.van_tag;

      case 'Sphynx':
        return s.sphynx_tag;

      case 'Tire':
        return s.tire_tag;

      case 'Denim':
        return s.denim_tag;

      case 'Prairie':
        return s.prairie_tag;

      case 'Snorkeling':
        return s.snorkeling_tag;

      case 'Umbrella':
        return s.umbrella_tag;

      case 'Asphalt':
        return s.asphalt_tag;

      case 'Sailboat':
        return s.sailboat_tag;

      case 'Basset hound':
        return s.basset_hound_tag;

      case 'Pattern':
        return s.pattern_tag;

      case 'Supper':
        return s.supper_tag;

      case 'Veil':
        return s.veil_tag;

      case 'Waterfall':
        return s.waterfall_tag;

      case 'Lunch':
        return s.lunch_tag;

      case 'Odometer':
        return s.odometer_tag;

      case 'Baby':
        return s.baby_tag;

      case 'Glasses':
        return s.glasses_tag;

      case 'Car':
        return s.car_tag;

      case 'Aircraft':
        return s.aircraft_tag;

      case 'Hand':
        return s.hand_tag;

      case 'Rodeo':
        return s.rodeo_tag;

      case 'Canyon':
        return s.canyon_tag;

      case 'Meal':
        return s.meal_tag;

      case 'Softball':
        return s.softball_tag;

      case 'Alcohol':
        return s.alcohol_tag;

      case 'Bride':
        return s.bride_tag;

      case 'Swamp':
        return s.swamp_tag;

      case 'Pie':
        return s.pie_tag;

      case 'Bag':
        return s.bag_tag;

      case 'Joker':
        return s.joker_tag;

      case 'Supervillain':
        return s.supervillain_tag;

      case 'Army':
        return s.army_tag;

      case 'Canoe':
        return s.canoe_tag;

      case 'Selfie':
        return s.selfie_tag;

      case 'Rickshaw':
        return s.rickshaw_tag;

      case 'Barn':
        return s.barn_tag;

      case 'Archery':
        return s.archery_tag;

      case 'Aerospace engineering':
        return s.aerospace_engineering_tag;

      case 'Storm':
        return s.storm_tag;

      case 'Helmet':
        return s.helmet_tag;

      default:
        return label;
    }
  }
}
