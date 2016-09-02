/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
        document.addEventListener('resume', this.onResume, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        app.receivedEvent('deviceready');
        zip.workerScriptsPath = "lib/";
        // zip.useWebWorkers = false;
    },

    onResume: function() {
        var keys = ['message', 'seat', 'flight', 'filekey', 'passenger', 'date', 'pkPassLocalFilePath'];

        console.log('Starting to get shared Pk Pass file...');
        window.cordova.plugins.ShareExtensionHandler.getJsonDataFromSharedPkpassFile(keys, function (result) {
            // var pkpassData = {};

            console.log('PkPass file successfully received:' + JSON.stringify(result));
        
            var blob = new Blob([result], {type: 'application/vnd.apple.pkpass'});
var fileReader = new FileReader();
                                                                                     fileReader.onload = function (evt) {
                                                                                     // Read out file contents as a Data URL
                                                                                     var result = evt.target.result;
                                                                                     // Set image src to Data URL
//                                                                                     rhino.setAttribute("src", result);
                                                                                     // Store Data URL in localStorage
                                                                                     try {
//                                                                                     localStorage.setItem("rhino", result);
//                                                                                     console.log(result);
                                                                                     zip.createReader(new zip.TextReader(result), function(reader) {
                                                                                                      
                                                                                                      // get all entries from the zip
                                                                                                      reader.getEntries(function(entries) {
                                                                                                                        if (entries.length) {
                                                                                                                        
                                                                                                                        // get first entry content as text
                                                                                                                        entries[0].getData(new zip.TextWriter(), function(text) {
                                                                                                                                           // text contains the entry data as a String
                                                                                                                                           console.log(text);
                                                                                                                                           
                                                                                                                                           // close the zip reader
                                                                                                                                           reader.close(function() {
                                                                                                                                                        // onclose callback
                                                                                                                                                        });
                                                                                                                                           
                                                                                                                                           }, function(current, total) {
                                                                                                                                           // onprogress callback
                                                                                                                                           console.log(total);
                                                                                                                                           });
                                                                                                                        }
                                                                                                                        }, function() {
                                                                                                                        console.log(arguments);
                                                                                                                        });
                                                                                                      }, function(error) {
                                                                                                      // onerror callback
                                                                                                      console.log(error);
                                                                                                      });

                                                                                     }
                                                                                     catch (e) {
                                                                                     console.log("Storage failed: " + e);
                                                                                     }
                                                                                     };
                                                                                     // Load blob as Data URL
                                                                                     fileReader.readAsDataURL(blob);
            
            // window.resolveLocalFileSystemURL(cordova.file.cacheDirectory, function (entry) { // jshint ignore: line 
            //     console.log('cdvfile URI: ' + entry.toInternalURL());

            //     entry.getFile('myfile.pkpass', { create: false, exclusive: false }, function (fileEntry) {
            //             // writeFile(fileEntry, fileData);
            //             console.log(fileEntry);
            //             fileEntry.file(function (file) {
            //                 var reader = new FileReader();

            //                 reader.onloadend = function() {
            //                     console.log("Successful file read: " + this.result);
            //                 };

            //                 reader.readAsText(file);

            //                 }, function() {
            //                     console.log(arguments);
            //                 });
            //         }, function() {
            //             console.log(arguments);
            //         });
            //     }, function() {
            //     console.log(arguments);
            // });

            // pkpassData = boardingService.parseBoardingPass(result.message);
            // pkpassData.url = result.url;
            // pkpassData.seatNum = result.seat === "(null)" ? '' : result.seat;
            // pkpassData.flightNum = result.flight;
            // pkpassData.bookingCode = result.filekey;
            // pkpassData.lastName = result.passenger.split(', ')[0];
            // pkpassData.flightDate = result.date || null;
            // console.log('PkPass file converted successfully:' + JSON.stringify(pkpassData));

            // if (pkpassData.bookingCode && pkpassData.lastName) {
            //     journeysData = journeysService.getJourneysFromLocalStorage();
            //     checkJourneys(journeysData.journeys, pkpassData.bookingCode, pkpassData.lastName, pkpassData);
            // }

            window.cordova.plugins.ShareExtensionHandler.deletePkpass();
        }, false);
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    }
};

app.initialize();