require 'spec_helper'

describe "Viewing todo items" do
  let!(:todo_list) { TodoList.create(title: "Grocery list", description: "Groceries") }
  
  def visit_todo_list(list)
    visit "/todo_lists"
    within "#todo_list_#{todo_list.id}" do
      click_link "List Items"
    end
  end

  def create_todo_item(options={})
    options[:content] ||= "Milk"
    visit_todo_list(todo_list)
    click_link "New Todo Item"
    fill_in "Content", with: options[:content]
    click_button "Save"
  end

  it "is successful with valid content" do
    create_todo_item
    expect(page).to have_content("Added todo list item.")
    within("ul.todo_items") do
      expect(page).to have_content("Milk")
    end
  end

  it "displays an error if content field is empty" do
    create_todo_item(content: "")
    within("div.flash") do
      expect(page).to have_content("There was a problem adding that todo list item")
    end
    expect(page).to have_content("Content can't be blank")
  end

  it "displays an error if content field is less than 2 characters" do
    create_todo_item(content: "A")
    within("div.flash") do
      expect(page).to have_content("There was a problem adding that todo list item")
    end
    expect(page).to have_content("Content is too short")
  end

end
