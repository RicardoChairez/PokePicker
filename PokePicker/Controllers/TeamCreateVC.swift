//
//  ViewController.swift
//  poketest
//
//  Created by Chip Chairez on 7/22/22.
//

import UIKit
import Foundation

class TeamCreateVC: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var searchController = UISearchController()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pokemon1: PokemonMemberView!
    @IBOutlet weak var pokemon2: PokemonMemberView!
    @IBOutlet weak var pokemon3: PokemonMemberView!
    @IBOutlet weak var pokemon4: PokemonMemberView!
    @IBOutlet weak var pokemon5: PokemonMemberView!
    @IBOutlet weak var pokemon6: PokemonMemberView!
    
    var pokemons: [Pokemon] = []
    var filteredPokemons: [Pokemon] = []
    
    var selectedPokemon: PokemonMemberView?
    var pokemonViewIndex: Int = 0
    
    override func viewDidLoad() {
        pokemon1.delegate = self
        pokemon2.delegate = self
        pokemon3.delegate = self
        pokemon4.delegate = self
        pokemon5.delegate = self
        pokemon6.delegate = self
        selectedPokemon = pokemon1
        pokemon1.setBorder()
        
        PokemonManager.shared.delegate = self
        PokemonManager.shared.getPokemon()
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        //searchController.searchBar.sizeToFit()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PokemonCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.rowHeight = 51
        tableView.tableHeaderView = searchController.searchBar
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createPressed))
    }
    @objc func createPressed(){
        let newTeam = Team(context: context)
        newTeam.name = title
        newTeam.addToMembers(pokemon1.pokemon!)
        newTeam.addToMembers(pokemon2.pokemon!)
        newTeam.addToMembers(pokemon3.pokemon!)
        newTeam.addToMembers(pokemon4.pokemon!)
        newTeam.addToMembers(pokemon5.pokemon!)
        newTeam.addToMembers(pokemon6.pokemon!)
        
        do{
            try context.save()
        }
        catch{
            print(error.localizedDescription)
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    func setDefaultPokemon(){
        pokemon1.setPokemon(pokemon: pokemons[24])
        pokemon2.setPokemon(pokemon: pokemons[2])
        pokemon3.setPokemon(pokemon: pokemons[5])
        pokemon4.setPokemon(pokemon: pokemons[8])
        pokemon5.setPokemon(pokemon: pokemons[142])
        pokemon6.setPokemon(pokemon: pokemons[130])
    }
    
    func viewPokemon(index: Int){
        pokemonViewIndex = index
        performSegue(withIdentifier: "GoToViewPokemon", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "GoToViewPokemon"){
            let destination = segue.destination as! ViewPokemonVC
            let pokemon = filteredPokemons[pokemonViewIndex]
            destination.pokemon = pokemon
        }
    }
}

//MARK: - PokemonManagerDelegate

extension TeamCreateVC: PokemonManagerDelegate{
    func didGetPokemon(pokeArr: [Pokemon]) {
        pokemons = pokeArr
        filteredPokemons = pokemons
        setDefaultPokemon()
        tableView.reloadData()
    }
}

//MARK: - UISearchBarDelegate

extension TeamCreateVC: UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredPokemons = pokemons
            tableView.reloadData()
            return
        }
        filteredPokemons = pokemons.filter { $0.name!.lowercased().contains(filter.lowercased()) }
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource

extension TeamCreateVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PokemonCell
        let pokemon = filteredPokemons[indexPath.row]
        
        cell.name.text = pokemon.name
        cell.sprite?.image = UIImage(named: pokemon.spriteRef!)
        cell.sprite?.layer.magnificationFilter = CALayerContentsFilter.nearest
        cell.id.text = pokemon.id
        cell.selectionStyle = .gray
        return cell
    }
}

//MARK: - UITableViewDelegate

extension TeamCreateVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = filteredPokemons[indexPath.row]
        selectedPokemon?.setPokemon(pokemon: pokemon)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title:  "View", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.viewPokemon(index: indexPath.row)
            success(true)
        })
        modifyAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
}

//MARK: - PokemonSelectViewDelegate

extension TeamCreateVC: PokemonSelectViewDelegate{
    func didSelect(pokemonSelectView: PokemonMemberView) {
        if selectedPokemon != pokemonSelectView{
            selectedPokemon?.removeBorder()
            selectedPokemon = pokemonSelectView
        }
    }
}
