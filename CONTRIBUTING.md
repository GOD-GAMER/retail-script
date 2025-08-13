# Contributing to FiveM Retail Jobs Script

We love your input! We want to make contributing to this project as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## Development Process

We use GitHub to host code, to track issues and feature requests, as well as accept pull requests.

## Pull Requests

Pull requests are the best way to propose changes to the codebase. We actively welcome your pull requests:

1. Fork the repo and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes.
5. Make sure your code lints.
6. Issue that pull request!

## Any contributions you make will be under the MIT Software License

In short, when you submit code changes, your submissions are understood to be under the same [MIT License](http://choosealicense.com/licenses/mit/) that covers the project. Feel free to contact the maintainers if that's a concern.

## Report bugs using GitHub's [issue tracker](https://github.com/GOD-GAMER/retail-script/issues)

We use GitHub issues to track public bugs. Report a bug by [opening a new issue](https://github.com/GOD-GAMER/retail-script/issues/new).

## Write bug reports with detail, background, and sample code

**Great Bug Reports** tend to have:

- A quick summary and/or background
- Steps to reproduce
  - Be specific!
  - Give sample code if you can
- What you expected would happen
- What actually happens
- Notes (possibly including why you think this might be happening, or stuff you tried that didn't work)

## Development Guidelines

### Code Style

- Use consistent indentation (4 spaces for Lua)
- Follow Lua naming conventions
- Comment your code, especially complex logic
- Use meaningful variable and function names

### Lua Best Practices

```lua
-- Good
local function calculateTotalPrice(items)
    local total = 0
    for _, item in ipairs(items) do
        total = total + (item.price * item.quantity)
    end
    return total
end

-- Bad
local function calc(i)
    local t = 0
    for k,v in pairs(i) do
        t = t + v.p * v.q
    end
    return t
end
```

### Framework Compatibility

When adding new features, ensure compatibility with:
- ESX Framework
- QBCore Framework  
- Standalone mode

Example:
```lua
-- Always check framework before using specific functions
if Config.Framework == 'esx' then
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer then
        xPlayer.addMoney(amount)
    end
elseif Config.Framework == 'qbcore' then
    local Player = QBCore.Functions.GetPlayer(playerId)
    if Player then
        Player.Functions.AddMoney('cash', amount)
    end
else
    -- Standalone implementation
    TriggerClientEvent('retail:addMoney', playerId, amount)
end
```

### Performance Considerations

- Always consider server performance when adding features
- Use appropriate cleanup mechanisms for spawned entities
- Implement LOD (Level of Detail) for visual elements
- Test with multiple concurrent players

### Testing

Before submitting a pull request:

1. Test on a local FiveM server
2. Test with different frameworks (ESX, QBCore, Standalone)
3. Test with multiple concurrent players
4. Verify no console errors
5. Check memory usage and performance impact

### Documentation

When adding new features:

1. Update the README.md if necessary
2. Add comments to your code
3. Update API documentation for new exports
4. Add configuration options to config.lua with comments
5. Update CHANGELOG.md

## Feature Requests

We welcome feature requests! Please:

1. Check if the feature already exists
2. Search existing issues to avoid duplicates
3. Provide a clear description of the problem the feature would solve
4. Include examples of how the feature would be used
5. Consider the impact on performance and compatibility

## Code of Conduct

### Our Pledge

We pledge to make participation in our project a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, sex characteristics, gender identity and expression, level of experience, education, socio-economic status, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Our Standards

Examples of behavior that contributes to creating a positive environment include:

- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

### Our Responsibilities

Project maintainers are responsible for clarifying the standards of acceptable behavior and are expected to take appropriate and fair corrective action in response to any instances of unacceptable behavior.

## Getting Started

1. **Fork the repository**
2. **Clone your fork**
   ```bash
   git clone https://github.com/your-username/retail-script.git
   ```
3. **Create a feature branch**
   ```bash
   git checkout -b feature/awesome-new-feature
   ```
4. **Make your changes**
5. **Test thoroughly**
6. **Commit your changes**
   ```bash
   git commit -m "Add awesome new feature"
   ```
7. **Push to your fork**
   ```bash
   git push origin feature/awesome-new-feature
   ```
8. **Create a Pull Request**

## Questions?

Feel free to contact the maintainers if you have any questions about contributing!