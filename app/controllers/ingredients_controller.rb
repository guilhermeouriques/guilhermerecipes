class IngredientsController < ApplicationController
	before_action :set_ingredient, only: [:show, :edit, :update]
	#before_action :require_same_user, only: [:edit, :update, :destroy]
	before_action :require_admin, except: [:show, :index]

	def index
    @ingredients = Ingredient.paginate(page: params[:page], per_page: 5)
	end

	def new
		@ingredient = Ingredient.new
	end

	def create
		@ingredient = Ingredient.new(ingredient_params)
		if @ingredient.save
			flash[:success] = "Ingredient was successfully created"
			redirect_to ingredient_path(@ingredient)
		else
			render 'new'
		end
	end

	def show
		@ingredient_recipes = @ingredient.recipes.paginate(page: params[:page], per_page: 5)
	end

	def edit
		
	end

	def update
		if @ingredient.update(ingredient_params)
			flash[:success] = "Ingredient was updated successfully"
			redirect_to @ingredient
		else
			render 'edit'
		end
	end

	def destroy
		# if !@chef.admin?
		# 	@chef.destroy
		# 	flash[:danger] = "Chef and all associated recipes deleted!"
		# 	redirect_to chefs_path
		# end
	end

	private

		def ingredient_params
			params.require(:ingredient).permit(:name)
		end

		def set_ingredient
			@ingredient = Ingredient.find(params[:id])
		end

		# def require_same_user
		# 	if current_chef != @chef && !current_chef.admin?
		# 		flash[:danger] = "You can only edit or delete your own account"
		# 		redirect_to chefs_path
		# 	end
		# end

		def require_admin
			if !logged_in? || (logged_in? && !current_chef.admin?)
				flash[:danger] = "Only admin user can perform that action"
				redirect_to ingredients_path
			end
		end
end