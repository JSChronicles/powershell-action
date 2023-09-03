describe 'Write-Output' {
    it 'outputs a string' {
        Write-Output "Working!" | Should -Be 'Working!'
    }
}