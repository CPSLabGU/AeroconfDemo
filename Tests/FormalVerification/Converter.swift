// Converter.swift
// AeroconfDemo
// 
// Created by Morgan McColl.
// Copyright © 2024 Morgan McColl. All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above
//    copyright notice, this list of conditions and the following
//    disclaimer in the documentation and/or other materials
//    provided with the distribution.
// 
// 3. All advertising materials mentioning features or use of this
//    software must display the following acknowledgement:
// 
//    This product includes software developed by Morgan McColl.
// 
// 4. Neither the name of the author nor the names of contributors
//    may be used to endorse or promote products derived from this
//    software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// 
// -----------------------------------------------------------------------
// This program is free software; you can redistribute it and/or
// modify it under the above terms or under the terms of the GNU
// General Public License as published by the Free Software Foundation;
// either version 2 of the License, or (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program; if not, see http://www.gnu.org/licenses/
// or write to the Free Software Foundation, Inc., 51 Franklin Street,
// Fifth Floor, Boston, MA  02110-1301, USA.
// 

import FSM
import GUUnits
import InMemoryVariables
import LLFSMs
import Model

/// A converter LLFSM that is used to formally verify the conversion from centimetres to millimetres.
struct Converter: LLFSM {

    /// The arrangement of all LLFSMs.
    struct Arrangement: Model.Arrangement {

        /// A global sensor that reads a distance value as a `UInt8`. This value is represented in
        /// centimetres.
        @Sensor var distanceSensor = InMemorySensor(id: "distance", initialValue: UInt8(0))

        /// The only LLFSM in the arrangement.
        @Machine(sensors: (\.$distanceSensor, mapsTo: \.$sensorReading))
        var converter = Converter()

    }

    /// The environment resources available to this LLFSM.
    struct Environment: EnvironmentProtocol {

        // swiftlint:disable implicitly_unwrapped_optional

        /// The distance sensor.
        @ReadOnly var sensorReading: UInt8!

        // swiftlint:enable implicitly_unwrapped_optional

    }

    /// The variables local to this LLFSM.
    struct Context: ContextProtocol, EmptyInitialisable {

        /// The sensor reading represented in millimetres.
        var convertedValue = Millimetres_u(rawValue: 0)
    }

    /// The Initial state definition.
    @State(
        name: "Initial",
        uses: \.$sensorReading,
        onExit: {
            let currentDistance = Centimetres_u($0.sensorReading)
            $0.convertedValue = Millimetres_u(currentDistance)
        },
        transitions: {
            Transition(to: \.$exit)
        }
    )
    var initial

    /// The Finished state definition.
    @State(name: "Finished")
    var exit

    /// Define state `Initial` as the initial state of this machine.
    let initialState = \Self.$initial

}
