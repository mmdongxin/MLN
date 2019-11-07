
local _class = {
    _name = 'IdeaWaterfallCell',
    _version = '1.0'
}

---@public
function _class:new()
    local o = {}
    setmetatable(o, { __index = self })
    return o
end

---@public
function _class:cellView()
    self.cellLayout = LinearLayout(LinearType.VERTICAL):width(MeasurementType.MATCH_PARENT):height(MeasurementType.MATCH_PARENT)
    self.image = ImageView():width(MeasurementType.MATCH_PARENT):height(MeasurementType.WRAP_CONTENT):bgColor(_Color.DeepGray):cornerRadius(6)
    self.image:contentMode(ContentMode.SCALE_TO_FILL)
    self.cellLayout:addView(self.image)
    self.desc = Label():text("穿搭穿搭穿搭穿搭穿搭穿搭穿搭"):textColor(_Color.Black):fontSize(12):marginTop(8):lines(3)
    self.cellLayout:addView(self.desc)

    self.countLinear = View():width(MeasurementType.MATCH_PARENT):marginTop(8)
    self.cellLayout:addView(self.countLinear)

    self.authorhead = ImageView():width(25):height(25):bgColor(_Color.Gray):cornerRadius(45)
    self.countLinear:addView(self.authorhead)
    self.authorName = Label():text("熊大"):setMaxWidth(80):textColor(_Color.DeepGray):fontSize(12):marginLeft(28):setGravity(Gravity.CENTER_VERTICAL)
    self.countLinear:addView(self.authorName)

    self.likeImg = ImageView():width(25):height(25):marginRight(28):setGravity(MBit:bor(Gravity.CENTER_VERTICAL, Gravity.RIGHT)):image("https://s.momocdn.com/w/u/others/2019/10/22/1571734558042-mls_love.png")
    self.countLinear:addView(self.likeImg)
    self.likeCount = Label():text("111"):textColor(_Color.DeepGray):fontSize(12):setGravity(MBit:bor(Gravity.CENTER_VERTICAL, Gravity.RIGHT))--:marginLeft(3)
    self.countLinear:addView(self.likeCount)
    return self.cellLayout
end

return _class