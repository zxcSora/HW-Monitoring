
        ### Download DLL
        $download_url = "https://disk.bingo-boom.ru/s/xzctNdjF5HPJ6Pr/download"
        $request = Invoke-WebRequest -UseBasicParsing -Uri $download_url -MaximumRedirection 0 -ErrorAction Ignore
        $location = $request.Headers.Location
        $local_path = "$env:TEMP\OpenHardwareMonitorLib.dll"
        Invoke-WebRequest -UseBasicParsing -Uri $download_url -OutFile $local_path
        ### Get Sense
        [System.Reflection.Assembly]::LoadFile("$env:TEMP\\OpenHardwareMonitorLib.dll") | Out-Null
        $PC = New-Object OpenHardwareMonitor.Hardware.Computer
        $PC.CPUEnabled = $true
        # Add sense
        $PC.HDDEnabled = $true
        $PC.GPUEnabled = $true
        $PC.Us
        $PC.Open()

        ForEach ($hw in $PC.Hardware) {

            # CPU Sense
            If ($hw.HardwareType -eq "CPU") {
                $cpuname = $hw.Name
                ForEach ($sensor in $hw.Sensors) {
                    Write-Verbose $sensor

                    if ($sensor.SensorType -like "*Temp*") {

                        $sensorName = $sensor.Name

                        if ($sensor.Value) {

                            $output += "$sensorName$cpuCountText : " + $sensor.Value + " C`n"
                            $outperfdata += "'$sensorName$cpuCountText'=" + $sensor.Value + ";;$TjMax;; "
                            $CoreCount++
                        }
                    }
                }
                $cpuCount += 1
                $cpuCountText = "($cpuCount)"
            }

            # Nvidia GPU Sense
            If ($hw.HardwareType -eq "GpuNvidia") {
                $gpuname = $hw.Name
                ForEach ($sensor in $hw.Sensors) {
                    Write-Verbose $sensor

                    if ($sensor.SensorType -like "*Temp*") {

                        $sensorName = $sensor.Name

                        if ($sensor.Value) {

                            $output += "$sensorName$gpuCountText : " + $sensor.Value + " C`n"
                            $CoreCount++
                        }
                    }
                }
                $gpuCount += 1
                $gpuCountText = "($gpuCount)"
            }

        # Radeon GPU Sense

            If ($hw.HardwareType -eq "GpuAti") {
                $gpuname = $hw.Name
                ForEach ($sensor in $hw.Sensors) {
                    Write-Verbose $sensor

                    if ($sensor.SensorType -like "*Temp*") {

                        $sensorName = $sensor.Name

                        if ($sensor.Value) {

                            $output += "$sensorName$gpuCountText : " + $sensor.Value + " C`n"
                            $CoreCount++
                        }
                    }
                }
                $gpuCount += 1
                $gpuCountText = "($gpuCount)"
            }

        # HDD Sense

            If ($hw.HardwareType -eq "HDD") {
                $hddname = $hw.Name
                ForEach ($sensor in $hw.Sensors) {
                    Write-Verbose $sensor  

                    if ($sensor.SensorType -like "*Temp*") {

                        $sensorName = $sensor.Name
                        if ($sensor.Value) {

                            $output += "$sensorName$cpuCountText : " + $sensor.Value + " C`n"
                            $CoreCount++
                        }
                    }
                }
                $cpuCount += 1
                $cpuCountText = "($cpuCount)"
            }
        }
        Write-Host $output
        }