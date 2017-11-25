# expenses_controller

ExpensesCtrl = Brasil.new do
  def serialize_list(vendors)
    vendors.map { |v| v.serialize(:id, :vendor, :amount, :date) }
  end

  on true do
    set_response_as_json

    on get, root do
      on param('vendor') do |vendor|
        expenses = Expense.where(vendor: vendor)
        serialize_list(expenses)
        write_res_as_json(expenses: expenses)
      end

      expenses = Expense.all
      serialize_list(expenses)
      write_res_as_json(expenses: expenses)
    end

    on get, 'total' do
      write_res_as_json(total: Expense.summary)
    end

    on post, root do
      expense = parse_req_as_json
      Expense.create(expense)
      set_response_status(201)
      write_res_as_json(created: true)
    end
  end
end