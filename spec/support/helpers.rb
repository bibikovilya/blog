def body_as_json
  json_str_to_hash(response.body)
end

def body_array_as_json
  JSON.parse(response.body).map do |item|
    item.with_indifferent_access
  end
end

def json_str_to_hash(str)
  JSON.parse(str).with_indifferent_access
end

def logins_by_ip(arr, ip)
  arr.find { |i| i.keys.include? ip }[ip]
end
