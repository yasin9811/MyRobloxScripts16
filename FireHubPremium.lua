-- =============================================
--         FIREHUB PREMIUM - LUA UI
--      Delta Executor Compatible
--      Designed by FireHub Team
-- =============================================

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- =============================================
-- THEME
-- =============================================
local Theme = {
    Background    = Color3.fromRGB(18, 18, 22),
    Sidebar       = Color3.fromRGB(13, 13, 17),
    Panel         = Color3.fromRGB(22, 22, 28),
    Accent        = Color3.fromRGB(220, 40, 40),
    AccentDark    = Color3.fromRGB(160, 20, 20),
    AccentGlow    = Color3.fromRGB(255, 60, 60),
    Green         = Color3.fromRGB(40, 200, 80),
    Text          = Color3.fromRGB(230, 230, 235),
    TextDim       = Color3.fromRGB(130, 130, 140),
    TextDark      = Color3.fromRGB(80, 80, 90),
    Border        = Color3.fromRGB(35, 35, 45),
    SliderFill    = Color3.fromRGB(220, 40, 40),
    SliderBg      = Color3.fromRGB(40, 40, 50),
    ToggleOn      = Color3.fromRGB(220, 40, 40),
    ToggleOff     = Color3.fromRGB(55, 55, 65),
    ToggleKnob    = Color3.fromRGB(240, 240, 245),
    ItemHover     = Color3.fromRGB(28, 28, 35),
    SectionText   = Color3.fromRGB(90, 90, 105),
    ActiveSide    = Color3.fromRGB(220, 40, 40),
    InactiveSide  = Color3.fromRGB(200, 200, 210),
}

-- =============================================
-- UTILITY FUNCTIONS
-- =============================================
local function Create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            inst[k] = v
        end
    end
    for _, child in pairs(children or {}) do
        child.Parent = inst
    end
    if props and props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

local function Tween(inst, props, duration, style, dir)
    local info = TweenInfo.new(duration or 0.18, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    local tw = TweenService:Create(inst, info, props)
    tw:Play()
    return tw
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    handle = handle or frame
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- =============================================
-- MAIN WINDOW
-- =============================================
function Library:CreateWindow(config)
    config = config or {}
    local title = config.Title or "FireHub Premium"

    -- ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "FireHubPremium",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = (game.CoreGui ~= nil and pcall(function() game.CoreGui.Name = game.CoreGui.Name end) and game.CoreGui) or LocalPlayer.PlayerGui
    })

    -- Main Frame
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 660, 0, 420),
        Position = UDim2.new(0.5, -330, 0.5, -210),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = MainFrame })
    Create("UIStroke", { Color = Theme.Border, Thickness = 1.2, Parent = MainFrame })

    -- Drop Shadow
    local Shadow = Create("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.new(0, -15, 0, -15),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0,0,0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = 0,
        Parent = MainFrame,
    })

    -- Title Bar
    local TitleBar = Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = MainFrame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = TitleBar })
    -- Fix bottom corners of titlebar
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        ZIndex = 4,
        Parent = TitleBar,
    })

    -- Logo Icon (planet icon via ImageLabel)
    local LogoIcon = Create("Frame", {
        Name = "LogoIcon",
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 12, 0.5, -14),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 6,
        Parent = TitleBar,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = LogoIcon })
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "🚀",
        TextSize = 15,
        ZIndex = 7,
        Parent = LogoIcon,
    })

    -- Title Labels
    Create("TextLabel", {
        Name = "TitleMain",
        Size = UDim2.new(0, 120, 0, 18),
        Position = UDim2.new(0, 47, 0, 6),
        BackgroundTransparency = 1,
        Text = "firehub",
        TextColor3 = Theme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6,
        Parent = TitleBar,
    })
    Create("TextLabel", {
        Name = "TitleSub",
        Size = UDim2.new(0, 120, 0, 15),
        Position = UDim2.new(0, 47, 0, 23),
        BackgroundTransparency = 1,
        Text = "premium",
        TextColor3 = Theme.TextDim,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6,
        Parent = TitleBar,
    })

    -- Close Button
    local CloseBtn = Create("TextButton", {
        Name = "CloseBtn",
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -38, 0.5, -14),
        BackgroundColor3 = Theme.Panel,
        Text = "✕",
        TextColor3 = Theme.TextDim,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        BorderSizePixel = 0,
        ZIndex = 6,
        Parent = TitleBar,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = CloseBtn })
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(MainFrame, { Size = UDim2.new(0, 660, 0, 0) }, 0.22)
        wait(0.23)
        ScreenGui:Destroy()
    end)
    CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, { BackgroundColor3 = Theme.Accent }, 0.12) end)
    CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, { BackgroundColor3 = Theme.Panel }, 0.12) end)

    -- Minimize Button
    local MinBtn = Create("TextButton", {
        Name = "MinBtn",
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -70, 0.5, -14),
        BackgroundColor3 = Theme.Panel,
        Text = "—",
        TextColor3 = Theme.TextDim,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        BorderSizePixel = 0,
        ZIndex = 6,
        Parent = TitleBar,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = MinBtn })
    local minimized = false
    local ContentArea -- forward reference
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(MainFrame, { Size = UDim2.new(0, 660, 0, 44) }, 0.2)
        else
            Tween(MainFrame, { Size = UDim2.new(0, 660, 0, 420) }, 0.2)
        end
    end)
    MinBtn.MouseEnter:Connect(function() Tween(MinBtn, { BackgroundColor3 = Color3.fromRGB(50,50,60) }, 0.12) end)
    MinBtn.MouseLeave:Connect(function() Tween(MinBtn, { BackgroundColor3 = Theme.Panel }, 0.12) end)

    MakeDraggable(MainFrame, TitleBar)

    -- =============================================
    -- SIDEBAR
    -- =============================================
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 148, 1, -44),
        Position = UDim2.new(0, 0, 0, 44),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = MainFrame,
    })
    Create("Frame", {
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        ZIndex = 4,
        Parent = Sidebar,
    })

    -- "KULLANICI ARAYÜZÜ" label
    Create("TextLabel", {
        Name = "SideLabel",
        Size = UDim2.new(1, -20, 0, 18),
        Position = UDim2.new(0, 14, 0, 12),
        BackgroundTransparency = 1,
        Text = "KULLANICI ARAYÜZÜ",
        TextColor3 = Theme.SectionText,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4,
        Parent = Sidebar,
    })

    -- Sidebar nav list
    local NavList = Create("Frame", {
        Name = "NavList",
        Size = UDim2.new(1, 0, 1, -40),
        Position = UDim2.new(0, 0, 0, 36),
        BackgroundTransparency = 1,
        ZIndex = 4,
        Parent = Sidebar,
    })
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = NavList,
    })

    -- =============================================
    -- CONTENT AREA
    -- =============================================
    ContentArea = Create("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -148, 1, -44),
        Position = UDim2.new(0, 148, 0, 44),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = MainFrame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = ContentArea })

    -- Tab Pages container
    local Pages = {}
    local PageContainer = Create("Frame", {
        Name = "PageContainer",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 3,
        Parent = ContentArea,
    })

    -- =============================================
    -- TAB CREATION
    -- =============================================
    local Tabs = {}
    local ActiveTab = nil
    local TabButtons = {}

    local Icons = {
        Aimbot     = "🎯",
        Görüş      = "👁",
        Değiştirici = "🎨",
        Diğer      = "⚙",
        Hareket    = "🏃",
        Ayarlar    = "🔧",
        Koruma     = "🛡",
    }

    local function SetActiveTab(name)
        for n, page in pairs(Pages) do
            page.Visible = (n == name)
        end
        for n, btn in pairs(TabButtons) do
            if n == name then
                Tween(btn.BG, { BackgroundColor3 = Color3.fromRGB(30, 30, 40) }, 0.15)
                btn.Label.TextColor3 = Theme.Text
                btn.Indicator.BackgroundColor3 = Theme.Accent
                btn.Indicator.Visible = true
            else
                Tween(btn.BG, { BackgroundColor3 = Color3.fromRGB(0,0,0,0) }, 0.15)
                btn.BG.BackgroundTransparency = 1
                btn.Label.TextColor3 = Theme.TextDim
                btn.Indicator.Visible = false
            end
        end
        ActiveTab = name
    end

    local function AddNavTab(name, icon)
        local BtnFrame = Create("Frame", {
            Name = name .. "Tab",
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundTransparency = 1,
            ZIndex = 4,
            Parent = NavList,
        })

        local BG = Create("Frame", {
            Name = "BG",
            Size = UDim2.new(1, -8, 1, -4),
            Position = UDim2.new(0, 4, 0, 2),
            BackgroundColor3 = Theme.ItemHover,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 4,
            Parent = BtnFrame,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = BG })

        local Indicator = Create("Frame", {
            Name = "Indicator",
            Size = UDim2.new(0, 3, 0, 20),
            Position = UDim2.new(1, -3, 0.5, -10),
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            Visible = false,
            ZIndex = 5,
            Parent = BtnFrame,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = Indicator })

        local IconLbl = Create("TextLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 22, 0, 22),
            Position = UDim2.new(0, 12, 0.5, -11),
            BackgroundTransparency = 1,
            Text = icon or "•",
            TextSize = 14,
            ZIndex = 5,
            Parent = BtnFrame,
        })

        local NameLbl = Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, -44, 1, 0),
            Position = UDim2.new(0, 38, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Theme.TextDim,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 5,
            Parent = BtnFrame,
        })

        local Btn = Create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 6,
            Parent = BtnFrame,
        })

        TabButtons[name] = { BG = BG, Label = NameLbl, Indicator = Indicator }

        -- Create page
        local Page = Create("ScrollingFrame", {
            Name = name .. "Page",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            ZIndex = 3,
            Parent = PageContainer,
        })
        Create("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14),
            PaddingBottom = UDim.new(0, 10),
            Parent = Page,
        })
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 2),
            Parent = Page,
        })

        Pages[name] = Page

        Btn.MouseButton1Click:Connect(function()
            SetActiveTab(name)
        end)
        Btn.MouseEnter:Connect(function()
            if ActiveTab ~= name then
                Tween(BG, { BackgroundTransparency = 0, BackgroundColor3 = Theme.ItemHover }, 0.1)
            end
        end)
        Btn.MouseLeave:Connect(function()
            if ActiveTab ~= name then
                Tween(BG, { BackgroundTransparency = 1 }, 0.1)
            end
        end)

        return Page
    end

    -- =============================================
    -- ELEMENT CREATORS
    -- =============================================

    local function SectionLabel(parent, text)
        local lbl = Create("TextLabel", {
            Name = "Section_" .. text,
            Size = UDim2.new(1, 0, 0, 22),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Theme.SectionText,
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 4,
            Parent = parent,
        })
        return lbl
    end

    local function Toggle(parent, labelText, default, callback)
        local state = default or false

        local Row = Create("Frame", {
            Name = "Toggle_" .. labelText,
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundTransparency = 1,
            ZIndex = 4,
            Parent = parent,
        })

        Create("TextLabel", {
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = labelText,
            TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 5,
            Parent = Row,
        })

        -- Toggle Track
        local Track = Create("Frame", {
            Name = "Track",
            Size = UDim2.new(0, 36, 0, 18),
            Position = UDim2.new(1, -38, 0.5, -9),
            BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff,
            BorderSizePixel = 0,
            ZIndex = 5,
            Parent = Row,
        })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Track })

        -- Knob
        local Knob = Create("Frame", {
            Name = "Knob",
            Size = UDim2.new(0, 14, 0, 14),
            Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
            BackgroundColor3 = Theme.ToggleKnob,
            BorderSizePixel = 0,
            ZIndex = 6,
            Parent = Track,
        })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Knob })

        -- Optional green indicator dot (like in screenshots)
        -- (shown when toggled on using green color)

        local Btn = Create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 7,
            Parent = Row,
        })

        Btn.MouseButton1Click:Connect(function()
            state = not state
            Tween(Track, { BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff }, 0.15)
            Tween(Knob, { Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7) }, 0.15)
            if callback then callback(state) end
        end)

        Row.MouseEnter:Connect(function()
            Tween(Row, { BackgroundColor3 = Theme.ItemHover }, 0.1)
            Row.BackgroundTransparency = 0
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Row })
        end)
        Row.MouseLeave:Connect(function()
            Row.BackgroundTransparency = 1
        end)

        return {
            SetValue = function(val)
                state = val
                Tween(Track, { BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff }, 0.15)
                Tween(Knob, { Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7) }, 0.15)
            end,
            GetValue = function() return state end,
        }
    end

    local function Slider(parent, labelText, min, max, default, suffix, callback)
        local value = default or min

        local Row = Create("Frame", {
            Name = "Slider_" .. labelText,
            Size = UDim2.new(1, 0, 0, 44),
            BackgroundTransparency = 1,
            ZIndex = 4,
            Parent = parent,
        })

        Create("TextLabel", {
            Size = UDim2.new(0.5, 0, 0, 18),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = labelText,
            TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 5,
            Parent = Row,
        })

        local ValLbl = Create("TextLabel", {
            Size = UDim2.new(0.5, 0, 0, 18),
            Position = UDim2.new(0.5, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = tostring(value) .. (suffix or ""),
            TextColor3 = Theme.TextDim,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 5,
            Parent = Row,
        })

        -- Slider BG
        local SliderBg = Create("Frame", {
            Name = "SliderBg",
            Size = UDim2.new(1, 0, 0, 4),
            Position = UDim2.new(0, 0, 0, 28),
            BackgroundColor3 = Theme.SliderBg,
            BorderSizePixel = 0,
            ZIndex = 5,
            Parent = Row,
        })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SliderBg })

        -- Fill
        local pct = (value - min) / (max - min)
        local Fill = Create("Frame", {
            Name = "Fill",
            Size = UDim2.new(pct, 0, 1, 0),
            BackgroundColor3 = Theme.SliderFill,
            BorderSizePixel = 0,
            ZIndex = 6,
            Parent = SliderBg,
        })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Fill })

        -- Knob
        local SKnob = Create("Frame", {
            Name = "Knob",
            Size = UDim2.new(0, 12, 0, 12),
            Position = UDim2.new(pct, -6, 0.5, -6),
            BackgroundColor3 = Theme.ToggleKnob,
            BorderSizePixel = 0,
            ZIndex = 7,
            Parent = SliderBg,
        })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = SKnob })

        local dragging = false
        local InputBtn = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 20),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 8,
            Parent = Row,
        })

        local function UpdateSlider(input)
            local sliderPos = SliderBg.AbsolutePosition.X
            local sliderSize = SliderBg.AbsoluteSize.X
            local relative = math.clamp((input.Position.X - sliderPos) / sliderSize, 0, 1)
            value = math.floor(min + (max - min) * relative)
            ValLbl.Text = tostring(value) .. (suffix or "")
            Tween(Fill, { Size = UDim2.new(relative, 0, 1, 0) }, 0.05)
            Tween(SKnob, { Position = UDim2.new(relative, -6, 0.5, -6) }, 0.05)
            if callback then callback(value) end
        end

        InputBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                UpdateSlider(input)
            end
        end)
        InputBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                UpdateSlider(input)
            end
        end)

        return {
            SetValue = function(v)
                value = math.clamp(v, min, max)
                local r = (value - min) / (max - min)
                ValLbl.Text = tostring(value) .. (suffix or "")
                Fill.Size = UDim2.new(r, 0, 1, 0)
                SKnob.Position = UDim2.new(r, -6, 0.5, -6)
            end,
            GetValue = function() return value end,
        }
    end

    local function Dropdown(parent, labelText, options, default, callback)
        local selected = default or (options[1] or "")

        local Row = Create("Frame", {
            Name = "Dropdown_" .. labelText,
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundTransparency = 1,
            ZIndex = 4,
            Parent = parent,
        })

        Create("TextLabel", {
            Size = UDim2.new(0.5, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = labelText,
            TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 5,
            Parent = Row,
        })

        local DBtn = Create("TextButton", {
            Name = "DropBtn",
            Size = UDim2.new(0, 110, 0, 22),
            Position = UDim2.new(1, -112, 0.5, -11),
            BackgroundColor3 = Theme.Panel,
            Text = selected .. " ▾",
            TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            BorderSizePixel = 0,
            ZIndex = 5,
            Parent = Row,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = DBtn })
        Create("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = DBtn })

        local DropFrame = Create("Frame", {
            Name = "DropFrame",
            Size = UDim2.new(0, 110, 0, #options * 26 + 6),
            Position = UDim2.new(1, -112, 1, 2),
            BackgroundColor3 = Theme.Panel,
            BorderSizePixel = 0,
            Visible = false,
            ZIndex = 20,
            Parent = Row,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = DropFrame })
        Create("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = DropFrame })

        local open = false
        DBtn.MouseButton1Click:Connect(function()
            open = not open
            DropFrame.Visible = open
        end)

        for i, opt in ipairs(options) do
            local OBtn = Create("TextButton", {
                Name = "Option_" .. opt,
                Size = UDim2.new(1, -8, 0, 24),
                Position = UDim2.new(0, 4, 0, 4 + (i-1)*26),
                BackgroundColor3 = Theme.Panel,
                Text = opt,
                TextColor3 = Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 11,
                BorderSizePixel = 0,
                ZIndex = 21,
                Parent = DropFrame,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = OBtn })
            OBtn.MouseButton1Click:Connect(function()
                selected = opt
                DBtn.Text = opt .. " ▾"
                DropFrame.Visible = false
                open = false
                if callback then callback(selected) end
            end)
            OBtn.MouseEnter:Connect(function() Tween(OBtn, { BackgroundColor3 = Theme.ItemHover }, 0.08) end)
            OBtn.MouseLeave:Connect(function() Tween(OBtn, { BackgroundColor3 = Theme.Panel }, 0.08) end)
        end

        return {
            GetValue = function() return selected end,
            SetValue = function(v) selected = v; DBtn.Text = v .. " ▾" end,
        }
    end

    local function KeyBind(parent, labelText, defaultKey, callback)
        local key = defaultKey or "NONE"

        local Row = Create("Frame", {
            Name = "Keybind_" .. labelText,
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundTransparency = 1,
            ZIndex = 4,
            Parent = parent,
        })
        Create("TextLabel", {
            Size = UDim2.new(0.6, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = labelText,
            TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 5,
            Parent = Row,
        })
        local KBtn = Create("TextButton", {
            Size = UDim2.new(0, 60, 0, 22),
            Position = UDim2.new(1, -62, 0.5, -11),
            BackgroundColor3 = Theme.Panel,
            Text = key,
            TextColor3 = Theme.Text,
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            BorderSizePixel = 0,
            ZIndex = 5,
            Parent = Row,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = KBtn })
        Create("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = KBtn })

        local listening = false
        KBtn.MouseButton1Click:Connect(function()
            listening = true
            KBtn.Text = "..."
            KBtn.TextColor3 = Theme.Accent
        end)
        UserInputService.InputBegan:Connect(function(input, gpe)
            if listening and not gpe then
                listening = false
                local keyName = input.KeyCode.Name
                key = keyName
                KBtn.Text = keyName
                KBtn.TextColor3 = Theme.Text
                if callback then callback(key) end
            end
        end)
    end

    local function Label(parent, text)
        Create("TextLabel", {
            Name = "InfoLabel",
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Theme.TextDim,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            ZIndex = 4,
            Parent = parent,
        })
    end

    local function Separator(parent)
        local Sep = Create("Frame", {
            Name = "Separator",
            Size = UDim2.new(1, 0, 0, 1),
            BackgroundColor3 = Theme.Border,
            BorderSizePixel = 0,
            ZIndex = 4,
            Parent = parent,
        })
        Create("Frame", { Size = UDim2.new(0, 0, 0, 6), BackgroundTransparency = 1, Parent = parent })
    end

    -- =============================================
    -- BUILD TABS & FEATURES
    -- =============================================

    -- === AIMBOT TAB ===
    local AimbotPage = AddNavTab("Aimbot", Icons.Aimbot)
    SectionLabel(AimbotPage, "GENEL")
    Toggle(AimbotPage, "Aktifleştir", false, function(v) print("[FireHub] Aimbot:", v) end)
    Toggle(AimbotPage, "Sadece Görünürken Aktifleştir", true, function(v) end)
    Dropdown(AimbotPage, "Silah Grubu", {"Genel","Tabanca","Tüfek","Sniper"}, "Genel", function(v) end)
    Toggle(AimbotPage, "Tuşsuz Aimbot", true, function(v) end)
    Dropdown(AimbotPage, "Hedef Önceliği", {"Nişangah","En Yakın","Düşük Can"}, "Nişangah", function(v) end)
    Slider(AimbotPage, "FOV", 1, 180, 30, "", function(v) end)
    Slider(AimbotPage, "Yumuşaklık", 1, 100, 5, "", function(v) end)
    Separator(AimbotPage)
    SectionLabel(AimbotPage, "TRİGGERBOT")
    Toggle(AimbotPage, "Triggerbot", false, function(v) end)
    Slider(AimbotPage, "Gecikme (ms)", 0, 500, 80, "ms", function(v) end)
    KeyBind(AimbotPage, "Triggerbot Tuşu", "NONE")
    Separator(AimbotPage)
    SectionLabel(AimbotPage, "SEKMEME")
    Toggle(AimbotPage, "Sekmeme Azalt", false, function(v) end)
    Slider(AimbotPage, "Sekmeme Değeri", 0, 100, 50, "", function(v) end)

    -- === GÖRÜŞ (ESP) TAB ===
    local GorüşPage = AddNavTab("Görüş", Icons.Görüş)
    SectionLabel(GorüşPage, "GENEL")
    Toggle(GorüşPage, "Aktifleştir", false, function(v) print("[FireHub] ESP:", v) end)
    Toggle(GorüşPage, "Kutu ESP", true, function(v) end)
    Dropdown(GorüşPage, "Kutu Türü", {"Varsayılan","Köşeli","3D"}, "Varsayılan", function(v) end)
    Toggle(GorüşPage, "Oyuncu Adı", true, function(v) end)
    Toggle(GorüşPage, "Can Barı", true, function(v) end)
    Toggle(GorüşPage, "Mermi Barı", true, function(v) end)
    Toggle(GorüşPage, "Silah", true, function(v) end)
    Toggle(GorüşPage, "Mesafe", false, function(v) end)
    Separator(GorüşPage)
    SectionLabel(GorüşPage, "EŞYALAR")
    Toggle(GorüşPage, "Eşya ESP", false, function(v) end)
    Toggle(GorüşPage, "Düşük Eşya Filtrele", false, function(v) end)
    Separator(GorüşPage)
    SectionLabel(GorüşPage, "DİĞER")
    Toggle(GorüşPage, "Chams", false, function(v) end)
    Toggle(GorüşPage, "Glow ESP", false, function(v) end)
    Toggle(GorüşPage, "İskelet", false, function(v) end)

    -- === DEĞİŞTİRİCİLER TAB ===
    local DeğiştPage = AddNavTab("Değiştirici", Icons.Değiştirici)
    SectionLabel(DeğiştPage, "SİLAHLAR")
    Label(DeğiştPage, "Silah seçmek için bir silaha tıklayın.")
    Separator(DeğiştPage)
    SectionLabel(DeğiştPage, "BÖLÜM: Silahlar")
    Toggle(DeğiştPage, "Desert Eagle Skin", false, function(v) end)
    Toggle(DeğiştPage, "AK-47 Skin", false, function(v) end)
    Toggle(DeğiştPage, "AWP Skin", false, function(v) end)
    Toggle(DeğiştPage, "Glock-18 Skin", false, function(v) end)
    Separator(DeğiştPage)
    SectionLabel(DeğiştPage, "ELDİVENLER")
    Toggle(DeğiştPage, "Eldiven Aktif", false, function(v) end)
    Separator(DeğiştPage)
    SectionLabel(DeğiştPage, "AJANLAR")
    Toggle(DeğiştPage, "Ajan Değiştir", false, function(v) end)

    -- === DİĞER TAB ===
    local DiğerPage = AddNavTab("Diğer", Icons.Diğer)
    SectionLabel(DiğerPage, "GENEL")
    Toggle(DiğerPage, "Bunnyhop", false, function(v)
        if v then
            -- Bunnyhop logic
            local bh_conn
            bh_conn = UserInputService.JumpRequest:Connect(function()
                if not v then bh_conn:Disconnect() return end
                if LocalPlayer.Character then
                    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.FloorMaterial ~= Enum.Material.Air then
                        hum.Jump = true
                    end
                end
            end)
        end
    end)
    Toggle(DiğerPage, "İzleyici Listesi", false, function(v) end)
    Toggle(DiğerPage, "Vuruş Göstergesi", false, function(v) end)
    Toggle(DiğerPage, "Vuruş Sesi", false, function(v) end)
    Toggle(DiğerPage, "Vuruş İzi", false, function(v) end)
    Slider(DiğerPage, "Uzunluğu", 1, 20, 5, "", function(v) end)
    Toggle(DiğerPage, "Sol El Bıçak", false, function(v) end)
    Toggle(DiğerPage, "Envanter Kilidi Aç", false, function(v) end)
    Toggle(DiğerPage, "OBS Bypass", false, function(v) end)

    -- === HAREKET TAB ===
    local HareketPage = AddNavTab("Hareket", Icons.Hareket)
    SectionLabel(HareketPage, "GENEL")
    Toggle(HareketPage, "Otomatik Strafe", false, function(v) end)
    Toggle(HareketPage, "Hareket Strafe", false, function(v) end)
    Slider(HareketPage, "Strafe Hassasiyeti", 1, 100, 100, ".000", function(v) end)
    Toggle(HareketPage, "Fast Ladder", false, function(v) end)
    Toggle(HareketPage, "Edge Bug", false, function(v) end)
    Toggle(HareketPage, "Edge Bug Tuşa Basılıyken", false, function(v) end)
    KeyBind(HareketPage, "Edge Bug Tuşu", "SHIFT")
    Toggle(HareketPage, "Edge Jump", false, function(v) end)
    Toggle(HareketPage, "Auto Crouch", false, function(v) end)
    Slider(HareketPage, "Hız Çarpanı", 1, 10, 1, "x", function(v) end)

    -- === AYARLAR TAB ===
    local AyarlarPage = AddNavTab("Ayarlar", Icons.Ayarlar)
    SectionLabel(AyarlarPage, "GÖRÜNÜM")
    Dropdown(AyarlarPage, "Tema", {"Kırmızı","Mavi","Yeşil","Turuncu"}, "Kırmızı", function(v) end)
    Slider(AyarlarPage, "UI Opaklığı", 0, 100, 90, "%", function(v) end)
    Separator(AyarlarPage)
    SectionLabel(AyarlarPage, "KLAVYE KISAYOLLARI")
    KeyBind(AyarlarPage, "Menü Aç/Kapat", "INSERT")
    KeyBind(AyarlarPage, "Panik Tuşu", "END")
    Separator(AyarlarPage)
    SectionLabel(AyarlarPage, "HESAP")
    Label(AyarlarPage, "FireHub Premium - Aktif Lisans")
    Label(AyarlarPage, "Sürüm: v2.5.1 | Delta Uyumlu")

    -- === KORUMA TAB ===
    local KorumaPage = AddNavTab("Koruma", Icons.Koruma)
    SectionLabel(KorumaPage, "KORUMA")
    local prot_entries = {
        "Orbit Premium VAC-Live Koruma Bloğu - Değer - XsnuxzCo1XBVP6mM",
        "Orbit Premium VAC-Live Koruma Bloğu - Değer - Ut6335dXNdZmCc64",
        "Orbit Premium VAC-Live Koruma Bloğu - Değer - zIraecjIGLpR0fR2",
        "Orbit Premium VAC-Live Koruma Bloğu - Değer - wqKGXXP3cn7O5zSx",
        "Orbit Premium VAC-Live Koruma Bloğu - Değer - Sel4B4FVubii3hWF",
        "FireHub Premium VAC-Live Koruma Bloğu - Değer - NJzOmM3OX0uod1kI",
        "FireHub Premium VAC-Live Koruma Bloğu - Değer - a2HH9Fgil4W8NUK5",
        "FireHub Premium Anti-Cheat Bypass - Aktif",
    }
    for _, txt in ipairs(prot_entries) do
        local Row = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundColor3 = Theme.Panel,
            BorderSizePixel = 0,
            ZIndex = 4,
            Parent = KorumaPage,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = Row })
        Create("TextLabel", {
            Size = UDim2.new(0, 70, 1, 0),
            BackgroundTransparency = 1,
            Text = "KORUMA",
            TextColor3 = Theme.Accent,
            Font = Enum.Font.GothamBold,
            TextSize = 9,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 5,
            Parent = Row,
        })
        Create("UIPadding", { PaddingLeft = UDim.new(0, 8), Parent = Row })
        Create("TextLabel", {
            Size = UDim2.new(1, -70, 1, 0),
            Position = UDim2.new(0, 62, 0, 0),
            BackgroundTransparency = 1,
            Text = txt,
            TextColor3 = Theme.TextDim,
            Font = Enum.Font.Gotham,
            TextSize = 9,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 5,
            Parent = Row,
        })
    end

    -- =============================================
    -- ACTIVATE FIRST TAB
    -- =============================================
    SetActiveTab("Aimbot")

    -- =============================================
    -- KEYBIND: INSERT to toggle
    -- =============================================
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.Insert then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    -- =============================================
    -- OPEN ANIMATION
    -- =============================================
    MainFrame.Size = UDim2.new(0, 660, 0, 0)
    Tween(MainFrame, { Size = UDim2.new(0, 660, 0, 420) }, 0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    print("[FireHub Premium] UI Yüklendi! INSERT tuşu ile aç/kapat.")

    return {
        MainFrame = MainFrame,
        ScreenGui = ScreenGui,
    }
end

-- =============================================
-- LAUNCH
-- =============================================
Library:CreateWindow({ Title = "FireHub Premium" })
