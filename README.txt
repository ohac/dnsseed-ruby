This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

Running
-------

To bootstrap call ruby bitcoin-scan.rb (the ip of a known-good node)
ie
ruby bitcoin-scan.rb `dig +short block-explorer.com`
warning: this node will end up in the database, so call a node by its public ip
followed by repeated calls to ruby bitcoin-scan-net.rb which will fill the dbs
quite quickly.
bitcoin-scan-net.rb should also be put on an appropriate cron job, checking
to make sure it isnt already running (which would just duplicate effort)
