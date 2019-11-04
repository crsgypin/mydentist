class Line::Message < ApplicationRecord
	enum source: {"server" => 1, "client" => 2}
	enum source_type: {"push" => 1, "reply" => 2}
	enum status: {"成功" => 1, "失敗" => 2}

end
