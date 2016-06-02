def repeat?(int)
    int_array = int.to_s.chars
    last_index = int_array.size - 1
    int_array.each_with_index do |number, index|
        if index < last_index
            return true if number == int_array[index+1]
        end
    end
    return false
end

def count_Numbers(arr)
    arr.each do |sub_array|
        min = sub_array[0]
        max = sub_array[1]
        count = 0
        (min..max).each do |value|
            if repeat?(value)
                count += 1
            end
        end
        puts count
    end
end
