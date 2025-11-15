class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy]
  allow_unauthenticated_access only: %i[ index show ]

  # The before_action is a Rails controller callback, it runs the method set_product (we defined below)
  # only: this is a keyoard that restricts when the filter runs
  # %i[ show edit update] is the same as [:show, :edit, :update]
  def index
    @products = Product.all
  end

  def new
    @product = Product.new # This will return information for the form to make a new product
  end
  #n Rails, controller actions don’t have to render HTML views — they just need to send 
  # some kind of response. By default, if you don’t explicitly render or redirect, Rails 
  # will look for a template (like app/views/products/show.html.erb).
  # for each controller method we need to render an html content
  def show # we get out query params in a params dict
    #render plain: "Product (ID:#{params[:id]}): #{Product.find(params[:id])}"
  end
  # this renders plain text so we don't need to make an html template

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product # WHEN redirect_to is given an Active Record object we generate a path for that record's show action
      # and bc our Active record is an instance of Product model which pluralizes the model name and takes the object's ID
      # WHERE DID WE GET THE ID? the Product.save method returns ID. I guess rails has fixed this database action
    else
      render :new, status: :unprocessable_entity
      # what is :new ? Since we are in the ProductsController :new is the new.html.erb in products
      # the status: :unprocessable_entity means that we set the HTTP status to 422 and return that to the browser
      # so when we render the new.html.erb in the response header
    end
  end
  # How did we get the data from the form in new.html.erb? 
  # <%= form.text_field :name %> :name is the :name of the Product instance we made in products#new
  # SO WE SHOULD AVOID HAVING ATTRIBUTES IN THE PRODUCT MODEL WITH NAMES THAT ARE THE SAME AS THE
  # NAMES OF THE ROUTES
  # HERE ARE SOME NAMES TO AVOID:
  # new, save, create, destroy, update, delete, type, id, class, send, attributes

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to @product
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path # now we have defined what we will return so we don't return an html view for deleting
  end


  private
    def set_product
      @product = Product.find(params[:id]) # the code we have repeated in multiple methods
    end

    def product_params
      params.expect(product: [ :name, :description, :featured_image, :inventory_count ])
    end
    # WHAT IS product: ? 

end

#       Prefix Verb   URI Pattern                  Controller#Action
#         root GET    /                            products#index
#     products GET    /products(.:format)          products#index
#              POST   /products(.:format)          products#create
#  new_product GET    /products/new(.:format)      products#new
# edit_product GET    /products/:id/edit(.:format) products#edit
#      product GET    /products/:id(.:format)      products#show
#              PATCH  /products/:id(.:format)      products#update
#              PUT    /products/:id(.:format)      products#update
#              DELETE /products/:id(.:format)      products#destroy

# <prefix>_<url|path>

# the prefixes mean that we can use add them to path to get a path to our route that we can reference in codes
# The places where we can use these references are the HTML files for this controller
# We can name a route to a controller action manually: get "/dashboard", to: "pages#dashboard", as: "dashboard"

# HIDDEN RULE FOR: POST, PATCH, PUT, DELETE:
# For POST and GET they are supported by the native browser so we can route to here with links in the html
# For PATCH, PUT, DELETE
# DELETE: <%= button_to "Delete", product_path(@product), method: :delete %>
# PATCH/PUT: it will detect that our product is already saved when making a new one and update it
#            it does this with the persisted? == true

# products_path --> "/products"
# products_url  --> "http://localhost:3000/products"
# product_path(1) --> "/products/1"
# product_url(1) --> "http://localhost:3000/products/1"

# _path is relative path to current domain
# _url is the full URL