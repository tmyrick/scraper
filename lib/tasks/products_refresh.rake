namespace :products do
  desc "Rake task to refresh product data"
  task :refresh => :environment do
    log = ActiveSupport::Logger.new('log/products_refresh.log')
    log.info "Task started at #{Time.now} for #{Product.count} products"

    Product.all.each do |product|
      product.refresh_data
    end
    log.info "Task finished at #{Time.now}"
  end
end