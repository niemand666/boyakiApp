require 'rails_helper'

describe PostsController do
  describe 'GET #new' do
    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it "assigns the requested post to @post" do
      post = create(:post)
      get :edit, params: { id: post }
      expect(assigns(:post)).to eq post
    end

    it "renders the :edit template" do
      post = create(:post)
      get :edit, params: { id: post }
      expect(response).to render_template :edit
    end
  end

  describe 'GET #index' do
    it "populates an array of posts ordered by created_at DESC" do
      posts = create_list(:post, 3) 
      get :index
      expect(assigns(:posts)).to match(posts.sort{ |a, b| b.created_at <=> a.created_at } )
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end
end
