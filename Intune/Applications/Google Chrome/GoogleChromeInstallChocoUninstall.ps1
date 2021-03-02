$localprograms = choco list --localonly
if ($localprograms -like "*googlechrome*")
{
    choco uninstall googlechrome
}
Else
{
    choco uninstall googlechrome -y
}