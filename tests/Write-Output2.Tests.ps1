describe 'Write-Output' {
    it 'outputs a string' {
        Write-Output "Not Working!" | Should -Be 'Working!'
    }
}